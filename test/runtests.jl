using Test
using Libxc

# Wrap in an outer testset to get a full report if one test fails
@testset "Libxc.jl" begin

@testset "Metadata" begin
    @test Libxc.libxc_version ≥ v"5.1.0"
    @test Libxc.libxc_doi isa AbstractString
end

@testset "Functional list" begin
    available = available_functionals()
    @test :lda_x     in available
    @test :lda_c_vwn in available
    @test :lda_xc_teter93 in available
    @test :gga_x_pbe in available
    @test :gga_c_pbe in available
end

@testset "Functional construction" begin
    lda = Functional(:lda_x, n_spin=2)
    @test is_lda(lda)
    @test !is_gga(lda)
    @test !is_mgga(lda)
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
    gga_x = Functional(:gga_x_pbe)
    result = evaluate(gga_x, rho=rho, sigma=sigma, derivatives=0).zk
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

    tpss_x = Functional(:mgga_x_tb09, n_spin=1)
    evaluate!(tpss_x; rho, sigma, lapl, tau, vrho, vsigma, vtau, vlapl)
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

@testset "Reference extraction" begin
    lda = Functional(:lda_x)
    @test length(lda.references) == 2
    @test lda.references[1].doi  == "10.1017/S0305004100016108"
    @test lda.references[2].doi  == "10.1007/BF01340281"
end

@testset "Setting thresholds" begin
    lda = Functional(:lda_x)

    lda.density_threshold = 1e-4
    @test lda.density_threshold == 1e-4
    lda.density_threshold = 1e-6
    @test lda.density_threshold == 1e-6

    for field in (:zeta_threshold, :sigma_threshold, :tau_threshold)
        setproperty!(lda, field, 1e-4)
        @test getproperty(lda, field) == 1e-4
        setproperty!(lda, field, 1e-6)
        @test getproperty(lda, field) == 1e-6
    end
end

@testset "Read-only properties" begin
    lda = Functional(:lda_x)

    # LDA has none of these things
    allprops = [:exx_coefficient, :cam_alpha, :cam_beta, :cam_omega, :nlc_b, :nlc_C]
    for s in allprops
        @test isnothing(getproperty(lda, s))
    end

    # Global hybrid functional
    b3lyp = Functional(:hyb_gga_xc_b3lyp)
    @test b3lyp.exx_coefficient == 0.2
    @test isnothing(b3lyp.cam_alpha)
    @test isnothing(b3lyp.cam_beta)
    @test isnothing(b3lyp.nlc_b)

    # SCAN + VV10 correlation functional
    scan_vv10 = Functional(:xc_mgga_c_scan_vv10)
    @test isnothing(scan_vv10.exx_coefficient)
    @test isnothing(scan_vv10.cam_alpha)
    @test scan_vv10.nlc_b == 14.0
    @test scan_vv10.nlc_C == 0.0093
    @test !needs_laplacian(scan_vv10)

    # ωB97 functional
    ωB97 = Functional(:xc_hyb_gga_xc_wb97)
    @test isnothing(ωB97.exx_coefficient)
    @test ωB97.cam_alpha == 1.0
    @test ωB97.cam_beta  == -1.0
    @test ωB97.cam_omega == 0.4
    @test isnothing(ωB97.nlc_b)

    # ωB97x_v functional
    ωB97x_v = Functional(:xc_hyb_gga_xc_wb97x_v)
    @test isnothing(ωB97.exx_coefficient)
    @test ωB97x_v.cam_alpha == 1.0
    @test ωB97x_v.cam_beta  == -(1.0 - 0.167)
    @test ωB97x_v.cam_omega == 0.3
    @test ωB97x_v.nlc_b     == 6.0
    @test ωB97x_v.nlc_C     == 0.01
end
end  # outer wrapper
