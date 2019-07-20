using Test
using Libxc

@testset "Version" begin
    @test isa(Libxc.xc_version(), VersionNumber)
    @test isa(Libxc.xc_version_string(), String)
end

@testset "FuncReferType" begin
    refer = Libxc.FuncReferType(pointer("ref"), pointer("doi"), pointer("bibtex"))
    p = Ref{Libxc.FuncReferType}(refer)
    @test unsafe_string(Libxc.xc_func_reference_get_ref(p)) == "ref"
    @test unsafe_string(Libxc.xc_func_reference_get_doi(p)) == "doi"
    @test unsafe_string(Libxc.xc_func_reference_get_bibtex(p)) == "bibtex"
end

@testset "XCFuncInfoType" begin
    reff = Libxc.xc_func_alloc()
    Libxc.xc_func_init(reff, 1, 1)
    info_ref = Libxc.xc_func_get_info(reff)
    @test Libxc.xc_func_info_get_number(info_ref) == 1
    @test Libxc.xc_func_info_get_kind(info_ref) == 0
    @test Libxc.xc_func_info_get_name(info_ref) == "Slater exchange"
    @test Libxc.xc_func_info_get_family(info_ref) == 1
    @test Libxc.xc_func_info_get_flags(info_ref) == 143
    Libxc.xc_func_end(reff)
    Libxc.xc_func_free(reff)
end

@testset "XCFuncType xc calc" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    result = zeros(Float64, 5)

    ptr = Libxc.xc_func_alloc()
    Libxc.xc_func_init(ptr, Libxc.LDA_X, 1)
    Libxc.xc_lda_exc!(ptr, 5, rho, result)
    @test result ≈ [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194] atol=1e-5
    Libxc.xc_func_end(ptr)
    Libxc.xc_func_free(ptr)

    ptr = Libxc.xc_func_alloc()
    Libxc.xc_func_init(ptr, Libxc.GGA_X_PBE, 1)
    Libxc.xc_gga_exc!(ptr, 5, rho, sigma, result)
    @test result ≈ [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661] atol=1e-5
    Libxc.xc_func_end(ptr)
    Libxc.xc_func_free(ptr)
end

@testset "High-level interface" begin
    rho = [0.1, 0.2, 0.3, 0.4, 0.5]
    sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
    result = zeros(Float64, 5)

    # LDA
    func = Libxc.Functional(:lda_x)
    @test func.identifier == :lda_x
    @test func.number == 1
    @test func.family == Libxc.family_lda
    @test func.n_spin == 1

    Libxc.evaluate_lda!(func, rho, E=result)
    @test result ≈ [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194] atol=1e-5

    # GGA
    func = Libxc.Functional(:gga_x_pbe)
    @test func.identifier == :gga_x_pbe
    @test func.number == 101
    @test func.family == Libxc.family_gga
    @test func.n_spin == 1

    Libxc.evaluate_gga!(func, rho, sigma, E=result)
    @test result ≈ [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661] atol=1e-5
end
