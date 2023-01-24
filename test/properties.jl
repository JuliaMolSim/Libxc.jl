using Test
using Libxc

@testset "Metadata" begin
    @test Libxc.libxc_version ≥ v"6.0.0"
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
    @test all(i in supported_derivatives(lda) for i in 0:2)
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
