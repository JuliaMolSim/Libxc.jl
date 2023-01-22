const CuArray = CUDA.CuArray
const CuPtr   = CUDA.CuPtr
const CU_NULL = CUDA.CU_NULL
const OptCuArray = Union{CuArray{Float64}, CuPtr{Nothing}}

function evaluate!(func::Functional, ::Union{Val{:lda},Val{:hyb_lda}}, rho::CuArray{Float64};
                   zk::OptCuArray=CU_NULL,
                   vrho::OptCuArray=CU_NULL, v2rho2::OptCuArray=CU_NULL,
                   v3rho3::OptCuArray=CU_NULL, v4rho4::OptCuArray=CU_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)

    pointer = allocate_gpufunctional(func)
    @ccall libxc_gpu.xc_lda(pointer::Ptr{xc_func_type}, np::Csize_t, rho::CuPtr{Cdouble},
                            zk::CuPtr{Cdouble}, vrho::CuPtr{Cdouble}, v2rho2::CuPtr{Cdouble},
                            v3rho3::CuPtr{Cdouble}, v4rho4::CuPtr{Cdouble})::Cvoid
    deallocate_gpufunctional(pointer)
end


function evaluate!(func::Functional, ::Union{Val{:gga},Val{:hyb_gga}}, rho::CuArray{Float64};
        sigma::CuArray{Float64}, zk::OptCuArray=CU_NULL,
                   vrho::OptCuArray=CU_NULL, vsigma::OptCuArray=CU_NULL,
                   v2rho2::OptCuArray=CU_NULL, v2rhosigma::OptCuArray=CU_NULL,
                   v2sigma2::OptCuArray=CU_NULL,
                   v3rho3::OptCuArray=CU_NULL, v3rho2sigma::OptCuArray=CU_NULL,
                   v3rhosigma2::OptCuArray=CU_NULL, v3sigma3::OptCuArray=CU_NULL,
                   v4rho4::OptCuArray=CU_NULL, v4rho3sigma::OptCuArray=CU_NULL,
                   v4rho2sigma2::OptCuArray=CU_NULL, v4rhosigma3::OptCuArray=CU_NULL,
                   v4sigma4::OptCuArray=CU_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)

    pointer = allocate_gpufunctional(func)
    @ccall libxc_gpu.xc_gga(
        pointer::Ptr{xc_func_type}, np::Csize_t, rho::CuPtr{Cdouble}, sigma::CuPtr{Cdouble},
        zk::CuPtr{Cdouble},
        vrho::CuPtr{Cdouble}, vsigma::CuPtr{Cdouble}, v2rho2::CuPtr{Cdouble},
        v2rhosigma::CuPtr{Cdouble}, v2sigma2::CuPtr{Cdouble},
        v3rho3::CuPtr{Cdouble}, v3rho2sigma::CuPtr{Cdouble}, v3rhosigma2::CuPtr{Cdouble},
        v3sigma3::CuPtr{Cdouble},
        v4rho4::CuPtr{Cdouble}, v4rho3sigma::CuPtr{Cdouble}, v4rho2sigma2::CuPtr{Cdouble},
        v4rhosigma3::CuPtr{Cdouble}, v4sigma4::CuPtr{Cdouble}
    )::Cvoid
    deallocate_gpufunctional(pointer)
end


function evaluate!(func::Functional, ::Union{Val{:mgga},Val{:hyb_mgga}}, rho::CuArray{Float64};
                   sigma::CuArray{Float64}, tau::CuArray{Float64}, lapl::OptCuArray=CU_NULL,
                   zk::OptCuArray=CU_NULL,
                   vrho::OptCuArray=CU_NULL,
                   vsigma::OptCuArray=CU_NULL,
                   vlapl::OptCuArray=CU_NULL,
                   vtau::OptCuArray=CU_NULL,
                   v2rho2::OptCuArray=CU_NULL,
                   v2rhosigma::OptCuArray=CU_NULL,
                   v2rholapl::OptCuArray=CU_NULL,
                   v2rhotau::OptCuArray=CU_NULL,
                   v2sigma2::OptCuArray=CU_NULL,
                   v2sigmalapl::OptCuArray=CU_NULL,
                   v2sigmatau::OptCuArray=CU_NULL,
                   v2lapl2::OptCuArray=CU_NULL,
                   v2lapltau::OptCuArray=CU_NULL,
                   v2tau2::OptCuArray=CU_NULL,
                   v3rho3::OptCuArray=CU_NULL,
                   v3rho2sigma::OptCuArray=CU_NULL,
                   v3rho2lapl::OptCuArray=CU_NULL,
                   v3rho2tau::OptCuArray=CU_NULL,
                   v3rhosigma2::OptCuArray=CU_NULL,
                   v3rhosigmalapl::OptCuArray=CU_NULL,
                   v3rhosigmatau::OptCuArray=CU_NULL,
                   v3rholapl2::OptCuArray=CU_NULL,
                   v3rholapltau::OptCuArray=CU_NULL,
                   v3rhotau2::OptCuArray=CU_NULL,
                   v3sigma3::OptCuArray=CU_NULL,
                   v3sigma2lapl::OptCuArray=CU_NULL,
                   v3sigma2tau::OptCuArray=CU_NULL,
                   v3sigmalapl2::OptCuArray=CU_NULL,
                   v3sigmalapltau::OptCuArray=CU_NULL,
                   v3sigmatau2::OptCuArray=CU_NULL,
                   v3lapl3::OptCuArray=CU_NULL,
                   v3lapl2tau::OptCuArray=CU_NULL,
                   v3lapltau2::OptCuArray=CU_NULL,
                   v3tau3::OptCuArray=CU_NULL,
                   v4rho4::OptCuArray=CU_NULL,
                   v4rho3sigma::OptCuArray=CU_NULL,
                   v4rho3lapl::OptCuArray=CU_NULL,
                   v4rho3tau::OptCuArray=CU_NULL,
                   v4rho2sigma2::OptCuArray=CU_NULL,
                   v4rho2sigmalapl::OptCuArray=CU_NULL,
                   v4rho2sigmatau::OptCuArray=CU_NULL,
                   v4rho2lapl2::OptCuArray=CU_NULL,
                   v4rho2lapltau::OptCuArray=CU_NULL,
                   v4rho2tau2::OptCuArray=CU_NULL,
                   v4rhosigma3::OptCuArray=CU_NULL,
                   v4rhosigma2lapl::OptCuArray=CU_NULL,
                   v4rhosigma2tau::OptCuArray=CU_NULL,
                   v4rhosigmalapl2::OptCuArray=CU_NULL,
                   v4rhosigmalapltau::OptCuArray=CU_NULL,
                   v4rhosigmatau2::OptCuArray=CU_NULL,
                   v4rholapl3::OptCuArray=CU_NULL,
                   v4rholapl2tau::OptCuArray=CU_NULL,
                   v4rholapltau2::OptCuArray=CU_NULL,
                   v4rhotau3::OptCuArray=CU_NULL,
                   v4sigma4::OptCuArray=CU_NULL,
                   v4sigma3lapl::OptCuArray=CU_NULL,
                   v4sigma3tau::OptCuArray=CU_NULL,
                   v4sigma2lapl2::OptCuArray=CU_NULL,
                   v4sigma2lapltau::OptCuArray=CU_NULL,
                   v4sigma2tau2::OptCuArray=CU_NULL,
                   v4sigmalapl3::OptCuArray=CU_NULL,
                   v4sigmalapl2tau::OptCuArray=CU_NULL,
                   v4sigmalapltau2::OptCuArray=CU_NULL,
                   v4sigmatau3::OptCuArray=CU_NULL,
                   v4lapl4::OptCuArray=CU_NULL,
                   v4lapl3tau::OptCuArray=CU_NULL,
                   v4lapl2tau2::OptCuArray=CU_NULL,
                   v4lapltau3::OptCuArray=CU_NULL,
                   v4tau4::OptCuArray=CU_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)

    pointer = allocate_gpufunctional(func)
    @ccall libxc_gpu.xc_gga(
        pointer::Ptr{xc_func_type}, np::Csize_t, rho::CuPtr{Cdouble}, sigma::CuPtr{Cdouble},
        lapl::CuPtr{Cdouble}, tau::CuPtr{Cdouble},
        zk::CuPtr{Cdouble}, vrho::CuPtr{Cdouble}, vsigma::CuPtr{Cdouble},
        vlapl::CuPtr{Cdouble}, vtau::CuPtr{Cdouble},
        v2rho2::CuPtr{Cdouble}, v2rhosigma::CuPtr{Cdouble},
        v2rholapl::CuPtr{Cdouble}, v2rhotau::CuPtr{Cdouble},
        v2sigma2::CuPtr{Cdouble}, v2sigmalapl::CuPtr{Cdouble},
        v2sigmatau::CuPtr{Cdouble}, v2lapl2::CuPtr{Cdouble},
        v2lapltau::CuPtr{Cdouble}, v2tau2::CuPtr{Cdouble},
        v3rho3::CuPtr{Cdouble}, v3rho2sigma::CuPtr{Cdouble},
        v3rho2lapl::CuPtr{Cdouble}, v3rho2tau::CuPtr{Cdouble},
        v3rhosigma2::CuPtr{Cdouble}, v3rhosigmalapl::CuPtr{Cdouble},
        v3rhosigmatau::CuPtr{Cdouble}, v3rholapl2::CuPtr{Cdouble},
        v3rholapltau::CuPtr{Cdouble}, v3rhotau2::CuPtr{Cdouble},
        v3sigma3::CuPtr{Cdouble}, v3sigma2lapl::CuPtr{Cdouble},
        v3sigma2tau::CuPtr{Cdouble}, v3sigmalapl2::CuPtr{Cdouble},
        v3sigmalapltau::CuPtr{Cdouble}, v3sigmatau2::CuPtr{Cdouble},
        v3lapl3::CuPtr{Cdouble}, v3lapl2tau::CuPtr{Cdouble},
        v3lapltau2::CuPtr{Cdouble}, v3tau3::CuPtr{Cdouble},
        v4rho4::CuPtr{Cdouble}, v4rho3sigma::CuPtr{Cdouble},
        v4rho3lapl::CuPtr{Cdouble}, v4rho3tau::CuPtr{Cdouble},
        v4rho2sigma2::CuPtr{Cdouble}, v4rho2sigmalapl::CuPtr{Cdouble},
        v4rho2sigmatau::CuPtr{Cdouble}, v4rho2lapl2::CuPtr{Cdouble},
        v4rho2lapltau::CuPtr{Cdouble}, v4rho2tau2::CuPtr{Cdouble},
        v4rhosigma3::CuPtr{Cdouble}, v4rhosigma2lapl::CuPtr{Cdouble},
        v4rhosigma2tau::CuPtr{Cdouble}, v4rhosigmalapl2::CuPtr{Cdouble},
        v4rhosigmalapltau::CuPtr{Cdouble}, v4rhosigmatau2::CuPtr{Cdouble},
        v4rholapl3::CuPtr{Cdouble}, v4rholapl2tau::CuPtr{Cdouble},
        v4rholapltau2::CuPtr{Cdouble}, v4rhotau3::CuPtr{Cdouble},
        v4sigma4::CuPtr{Cdouble}, v4sigma3lapl::CuPtr{Cdouble},
        v4sigma3tau::CuPtr{Cdouble}, v4sigma2lapl2::CuPtr{Cdouble},
        v4sigma2lapltau::CuPtr{Cdouble}, v4sigma2tau2::CuPtr{Cdouble},
        v4sigmalapl3::CuPtr{Cdouble}, v4sigmalapl2tau::CuPtr{Cdouble},
        v4sigmalapltau2::CuPtr{Cdouble}, v4sigmatau3::CuPtr{Cdouble},
        v4lapl4::CuPtr{Cdouble}, v4lapl3tau::CuPtr{Cdouble},
        v4lapl2tau2::CuPtr{Cdouble}, v4lapltau3::CuPtr{Cdouble},
        v4tau4::CuPtr{Cdouble}
    )::Cvoid

    deallocate_gpufunctional(pointer)
end
