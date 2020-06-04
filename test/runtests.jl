using Test
using Libxc

# Wrap in an outer testset to get a full report if one test fails
@testset "Libxc.jl" begin

@testset "Version" begin
    @test isa(Libxc.xc_version(), VersionNumber)
end

@testset "Functional list" begin
    available = available_functionals()
    @test :lda_x in available
    @test :lda_c_vwn in available
    @test :lda_xc_teter93 in available
    @test :gga_x_pbe in available
    @test :gga_c_pbe in available
end

@testset "Functional construction" begin
    lda = Functional(:lda_x, n_spin=2)
    @test lda.family == :lda
    @test sort(lda.flags) == sort([:vxc, :dim3, :fxc, :exc])
    @test lda.kind == :exchange
    @test lda.name == "Slater exchange"
    @test lda.n_spin == 2
end

@testset "LDA and GGA evaluate" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    result = zeros(Float64, 5)

    # LDA
    lda_x = Functional(:lda_x)
    result = evaluate(lda_x, rho=rho, derivatives=0).zk
    @test result ≈ [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194] atol=1e-5

    # GGA
    lda_x = Functional(:gga_x_pbe)
    result = evaluate(lda_x, rho=rho, sigma=sigma, derivatives=0).zk
    @test result ≈ [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661] atol=1e-5
end

@testset "LDA and GGA evaluate!" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    result = zeros(Float64, 5)

    # LDA
    func = Functional(:lda_x)
    evaluate!(func, rho=rho, zk=result)
    @test result ≈ [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194] atol=1e-5

    # GGA
    func = Functional(:gga_x_pbe)
    evaluate!(func, rho=rho, sigma=sigma, zk=result)
    @test result ≈ [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661] atol=1e-5
end

@testset "LDA / GGA evaluate! with spin" begin
    rho = abs.(randn(5))
    sigma = abs.(randn(5))

    # Duplicate rho and sigma for spin = 2 tests
    rho2 = zeros(Float64, 2length(rho))
    rho2[1:2:end] = rho2[2:2:end] = rho ./ 2

    sigma2 = zeros(Float64, 3length(rho))
    sigma2[1:3:end] = sigma2[2:3:end] = sigma2[3:3:end] = sigma ./ 4

    # LSDA
    for sym in (:lda_x, :lda_c_vwn)
        E = zeros(Float64, length(rho))
        func = Functional(sym, n_spin=1)
        evaluate!(func, rho=rho, zk=E)

        E2 = zeros(Float64, length(rho))
        func = Functional(sym, n_spin=2)
        evaluate!(func, rho=rho2, zk=E2)

        @test E ≈ E2
    end

    # GGA
    for sym in (:gga_x_pbe, :gga_c_pbe)
        E = zeros(Float64, length(rho))
        func = Functional(sym, n_spin=1)
        evaluate!(func, rho=rho, sigma=sigma, zk=E)

        E2 = zeros(Float64, length(rho))
        func = Functional(sym, n_spin=2)
        evaluate!(func, rho=rho2, sigma=sigma2, zk=E2)

        @test E ≈ E2
    end
end

@testset "LDA / GGA evaluate with spin" begin
    shape = (2, 3, 4)
    rho = abs.(randn(shape))
    sigma = abs.(randn(shape))

    # Duplicate rho and sigma for spin = 2 tests
    rho2 = 0.5vcat(reshape(rho, 1, shape...), reshape(rho, 1, shape...))
    sigma2 = 0.25vcat(reshape(sigma, 1, shape...), reshape(sigma, 1, shape...),
                      reshape(sigma, 1, shape...))

    # LSDA
    for sym in (:lda_x, :lda_c_vwn)
        res = evaluate(Functional(sym, n_spin=1), rho=rho)
        @test size(res.zk) == shape
        @test size(res.vrho) == shape

        res2 = evaluate(Functional(sym, n_spin=2), rho=rho2)
        @test size(res2.zk) == shape
        @test size(res2.vrho) == (2, shape...)

        @test res.zk ≈ res2.zk
        @test res.vrho ≈ res2.vrho[1, :, :, :]
        @test res.vrho ≈ res2.vrho[2, :, :, :]
    end

    # GGA
    for sym in (:gga_x_pbe, :gga_c_pbe)
        res = evaluate(Functional(sym, n_spin=1), rho=rho, sigma=sigma)
        @test size(res.zk) == shape
        @test size(res.vrho) == shape
        @test size(res.vsigma) == shape

        res2 = evaluate(Functional(sym, n_spin=2), rho=rho2, sigma=sigma2)
        @test size(res2.zk) == shape
        @test size(res2.vrho) == (2, shape...)
        @test size(res2.vsigma) == (3, shape...)

        @test res.zk ≈ res2.zk
        @test res.vrho ≈ res2.vrho[1, :, :, :]
        @test res.vrho ≈ res2.vrho[2, :, :, :]
        @test 4res.vsigma ≈ dropdims(sum(res2.vsigma, dims=1), dims=1)
    end
end

@testset "mGGA evaluate!" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    lapl = [-0.2, -0.3, -0.4, -0.5, -0.6]
    tau = [0.5, 0.4, 0.3, 0.2, 0.1]
    result = zeros(Float64, 5)

    tpss_x = Functional(:mgga_x_tpss, n_spin=1)
    evaluate!(tpss_x, rho=rho, sigma=sigma, lapl=lapl, tau=tau, zk=result)
    @test result ≈ [-0.4254894, -0.4685985, -0.5341998, -0.6017734, -0.6646443] atol=1e-6
end

@testset "evaluate! with invalid arguments" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    func = Functional(:lda_x)

    # Derivatives ≥ 3 not compiled into libxc at the moment
    @test_throws ArgumentError evaluate(func, rho=rho, derivatives=3)

    @test_throws DimensionMismatch evaluate!(func, rho=rho, zk=randn(2))
end


end  # outer wrapper
