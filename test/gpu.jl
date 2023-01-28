using Test
using Libxc
using CUDA

@testset "Properties" begin
    @test CUDA.has_cuda()
end

@testset "Compare LDA on CPU/GPU" begin
    n_p = 12

    for n_spin in (1, 2), sym in (:lda_x, :lda_c_vwn)
        rho   = abs.(randn(n_spin, n_p))
        res   = evaluate(Functional(sym; n_spin); rho)

        rho_d   = convert(CuArray, rho)
        res_d   = evaluate(Functional(sym; n_spin); rho=rho_d)

        @test maximum(abs, res.zk   - Array(res_d.zk))   < 1e-12
        @test maximum(abs, res.vrho - Array(res_d.vrho)) < 1e-12
    end
end

@testset "Compare GGA on CPU/GPU" begin
    n_p = 12

    for n_spin in (1, 2), sym in (:gga_x_pbe, :gga_c_pbe)
        rho   = abs.(randn(n_spin,    n_p))
        sigma = abs.(randn(2n_spin-1, n_p))
        res   = evaluate(Functional(sym; n_spin); rho, sigma)

        rho_d   = convert(CuArray, rho)
        sigma_d = convert(CuArray, sigma)
        res_d   = evaluate(Functional(sym; n_spin); rho=rho_d, sigma=sigma_d)

        @test maximum(abs, res.zk     - Array(res_d.zk))     < 1e-12
        @test maximum(abs, res.vrho   - Array(res_d.vrho))   < 1e-12
        @test maximum(abs, res.vsigma - Array(res_d.vsigma)) < 1e-12
    end
end


@testset "Compare mGGA without Laplacian" begin
    n_p = 12

    for n_spin in (1, 2), sym in (:mgga_x_tpss, )
        rho   = abs.(randn(n_spin,    n_p))
        sigma = abs.(randn(2n_spin-1, n_p))
        tau   = abs.(randn(n_spin,    n_p))
        res   = evaluate(Functional(sym; n_spin); rho, sigma, tau)

        rho_d   = convert(CuArray, rho)
        sigma_d = convert(CuArray, sigma)
        tau_d   = convert(CuArray, tau)
        res_d   = evaluate(Functional(sym; n_spin); rho=rho_d, sigma=sigma_d, tau=tau_d)

        @test_broken maximum(abs, res.zk     - Array(res_d.zk))     < 1e-12
        @test_broken maximum(abs, res.vrho   - Array(res_d.vrho))   < 1e-12
        @test_broken maximum(abs, res.vsigma - Array(res_d.vsigma)) < 1e-12
        @test_broken maximum(abs, res.vtau   - Array(res_d.vtau))   < 1e-12
    end
end
