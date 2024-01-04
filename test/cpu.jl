using Test
using Libxc

@testset "LDA and GGA evaluate" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    result = zeros(Float64, 5)

    # LDA
    lda_x = Functional(:lda_x)
    result = evaluate(lda_x, rho=rho, derivatives=0:1)
    @test result.zk ≈ [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194] atol=1e-5

    # GGA
    gga_x = Functional(:gga_x_pbe)
    result = evaluate(gga_x, rho=rho, sigma=sigma, derivatives=0:1)
    @test result.zk ≈ [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661] atol=1e-5
end

@testset "Hybrid LDA and Hybrid GGA evaluate" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    result = zeros(Float64, 5)

    # LDA
    hyb_lda_xc = Functional(:hyb_lda_xc_bn05)
    result = evaluate(hyb_lda_xc, rho=rho, derivatives=0:1)
    @test result.zk ≈ [-0.162837, -0.234719, -0.286980, -0.329442, -0.365816] atol=1e-5

    # GGA
    gga_x = Functional(:hyb_gga_x_s12h)
    result = evaluate(gga_x, rho=rho, sigma=sigma, derivatives=0:1)
    @test result.zk ≈ [-0.350425, -0.362603, -0.389472, -0.421598, -0.452075] atol=1e-5
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
    rho   = reshape(abs.(randn(shape)), 1, shape...)
    sigma = reshape(abs.(randn(shape)), 1, shape...)

    # Duplicate rho and sigma for spin = 2 tests
    rho2 = 0.5vcat(rho, rho)
    sigma2 = 0.25vcat(sigma, sigma, sigma)

    # LSDA
    for sym in (:lda_x, :lda_c_vwn)
        res = evaluate(Functional(sym, n_spin=1), rho=rho, zk=zeros(shape))
        @test size(res.zk) == shape
        @test size(res.vrho) == (1, shape...)

        res2 = evaluate(Functional(sym, n_spin=2), rho=rho2)
        @test size(res2.zk) == shape
        @test size(res2.vrho) == (2, shape...)

        @test res.zk ≈ res2.zk
        @test res.vrho[1, :, :, :] ≈ res2.vrho[1, :, :, :]
        @test res.vrho[1, :, :, :] ≈ res2.vrho[2, :, :, :]
    end

    # GGA
    for sym in (:gga_x_pbe, :gga_c_pbe)
        res = evaluate(Functional(sym, n_spin=1), rho=rho, sigma=sigma)
        @test size(res.zk) == shape
        @test size(res.vrho) == (1, shape...)
        @test size(res.vsigma) == (1, shape...)

        res2 = evaluate(Functional(sym, n_spin=2), rho=rho2, sigma=sigma2)
        @test size(res2.zk) == shape
        @test size(res2.vrho) == (2, shape...)
        @test size(res2.vsigma) == (3, shape...)

        @test res.zk ≈ res2.zk
        @test res.vrho[1, :, :, :] ≈ res2.vrho[1, :, :, :]
        @test res.vrho[1, :, :, :] ≈ res2.vrho[2, :, :, :]
        @test 4res.vsigma ≈ sum(res2.vsigma, dims=1)
    end
end

@testset "mGGA evaluate! without Laplacian" begin
    rho    = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma  = [0.2, 0.3, 0.4, 0.5, 0.6]
    tau    = [0.5, 0.4, 0.3, 0.2, 0.1]
    result = zeros(Float64, 5)

    tpss_x = Functional(:mgga_x_tpss, n_spin=1)
    evaluate!(tpss_x, rho=rho, sigma=sigma, tau=tau, zk=result)
    @test result ≈ [-0.4254894, -0.4685985, -0.5341998, -0.6017734, -0.6646443] atol=1e-6
end

@testset "mGGA evaluate! with Laplacian" begin
    rho    = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma  = [0.2, 0.3, 0.4, 0.5, 0.6]
    lapl   = [-0.2, -0.3, -0.4, -0.5, -0.6]
    tau    = [0.5, 0.4, 0.3, 0.2, 0.1]
    vrho   = randn(Float64, 5)
    vsigma = randn(Float64, 5)
    vtau   = randn(Float64, 5)
    vlapl  = randn(Float64, 5)

    # TB09 is a potential functional, construct and check this
    tb09_x = Functional(:mgga_x_tb09, n_spin=1)
    @test all(i in supported_derivatives(tb09_x) for i in 1:2)
    @test !(0 in supported_derivatives(tb09_x))

    evaluate!(tb09_x; rho, sigma, lapl, tau, vrho, vsigma, vtau, vlapl)
    @test vrho ≈ [ 0.07015148, -0.4085103, -0.73564854, -0.97043302, -1.15268102] atol=1e-6
    @test iszero(vsigma)
    @test iszero(vtau)
    @test iszero(vlapl)
end

@testset "evaluate! with invalid arguments" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    func = Functional(:lda_x)

    # Derivatives ≥ 3 not compiled into libxc at the moment
    @test_throws ArgumentError evaluate(func, rho=rho, derivatives=0:3)
    @test_throws ArgumentError evaluate!(func, rho=rho, v3rho3=randn(5))

    @test_throws DimensionMismatch evaluate!(func, rho=rho, zk=randn(2))
end

@testset "Custom evaluate! dispatch" begin
    # A dummy version of Slater exchange for Float32
    function Libxc.evaluate!(func::Functional, ::Val{:lda}, rho::Array{Float32};
                             zk::Array{Float32})
        @assert func.identifier == :lda_x
        @. zk = -Float32(3/4) * cbrt(Float32(3/π) * rho)
    end
    rho = Float32[0.1, 0.2, 0.3, 0.4, 0.5]
    result = zeros(Float32, 5)
    func = Functional(:lda_x)

    res = evaluate(func, rho=rho, derivatives=0)
    @test eltype(res.zk) == Float32
    @test eltype(res.zk) == Float32
    @test res.zk ≈ [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194] atol=1e-5
end
