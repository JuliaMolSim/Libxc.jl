module LibxcAMDGPUExt
using Libxc: Libxc, xc_func_type, Functional, amdgpu_libxc_path
using AMDGPU

const libxc_amdgpu = amdgpu_libxc_path()
if !isnothing(libxc_amdgpu)
const ROCArray   = AMDGPU.ROCArray
const OptROCArray = Union{ROCArray{Float64}, Ptr{Nothing}}

function allocate_amdgpufunctional(identifier::Symbol, n_spin::Integer)
    n_spin in (1, 2) || error("n_spin needs to be 1 or 2")

    number  = @ccall libxc_amdgpu.xc_functional_get_number(string(identifier)::Cstring)::Cint
    number == -1 && error("Functional $identifier is not known.")

    pointer = @ccall libxc_amdgpu.xc_func_alloc()::Ptr{xc_func_type}
    ret = @ccall libxc_amdgpu.xc_func_init(pointer::Ptr{xc_func_type}, number::Cint,
                                           n_spin::Cint)::Cint
    ret != 0 && error("Something went wrong initialising the functional")

    pointer
end
allocate_amdgpufunctional(func::Functional) = allocate_amdgpufunctional(func.identifier, func.n_spin)

function deallocate_amdgpufunctional(pointer::Ptr{xc_func_type})
    if pointer != C_NULL
        @ccall libxc_amdgpu.xc_func_end(pointer::Ptr{xc_func_type})::Cvoid
        @ccall libxc_amdgpu.xc_func_free(pointer::Ptr{xc_func_type})::Cvoid
    end
end


function Libxc.evaluate!(func::Functional, ::Union{Val{:lda},Val{:hyb_lda}}, rho::ROCArray{Float64};
                         zk::OptROCArray=C_NULL,
                         vrho::OptROCArray=C_NULL, v2rho2::OptROCArray=C_NULL,
                         v3rho3::OptROCArray=C_NULL, v4rho4::OptROCArray=C_NULL)
    n_p = div(length(rho), func.spin_dimensions.rho)
    pointer = allocate_amdgpufunctional(func)
    @ccall libxc_amdgpu.xc_lda(pointer::Ptr{xc_func_type}, n_p::Csize_t, rho::Ptr{Cdouble},
                            zk::Ptr{Cdouble}, vrho::Ptr{Cdouble}, v2rho2::Ptr{Cdouble},
                            v3rho3::Ptr{Cdouble}, v4rho4::Ptr{Cdouble})::Cvoid
    deallocate_amdgpufunctional(pointer)
end


function Libxc.evaluate!(func::Functional, ::Union{Val{:gga},Val{:hyb_gga}}, rho::ROCArray{Float64};
                         sigma::ROCArray{Float64}, zk::OptROCArray=C_NULL,
                         vrho::OptROCArray=C_NULL, vsigma::OptROCArray=C_NULL,
                         v2rho2::OptROCArray=C_NULL, v2rhosigma::OptROCArray=C_NULL,
                         v2sigma2::OptROCArray=C_NULL,
                         v3rho3::OptROCArray=C_NULL, v3rho2sigma::OptROCArray=C_NULL,
                         v3rhosigma2::OptROCArray=C_NULL, v3sigma3::OptROCArray=C_NULL,
                         v4rho4::OptROCArray=C_NULL, v4rho3sigma::OptROCArray=C_NULL,
                         v4rho2sigma2::OptROCArray=C_NULL, v4rhosigma3::OptROCArray=C_NULL,
                         v4sigma4::OptROCArray=C_NULL)
    n_p = div(length(rho), func.spin_dimensions.rho)
    pointer = allocate_amdgpufunctional(func)
    @ccall libxc_amdgpu.xc_gga(
        pointer::Ptr{xc_func_type}, n_p::Csize_t, rho::Ptr{Cdouble}, sigma::Ptr{Cdouble},
        zk::Ptr{Cdouble},
        vrho::Ptr{Cdouble}, vsigma::Ptr{Cdouble}, v2rho2::Ptr{Cdouble},
        v2rhosigma::Ptr{Cdouble}, v2sigma2::Ptr{Cdouble},
        v3rho3::Ptr{Cdouble}, v3rho2sigma::Ptr{Cdouble}, v3rhosigma2::Ptr{Cdouble},
        v3sigma3::Ptr{Cdouble},
        v4rho4::Ptr{Cdouble}, v4rho3sigma::Ptr{Cdouble}, v4rho2sigma2::Ptr{Cdouble},
        v4rhosigma3::Ptr{Cdouble}, v4sigma4::Ptr{Cdouble}
    )::Cvoid
    deallocate_amdgpufunctional(pointer)
end


function Libxc.evaluate!(func::Functional, ::Union{Val{:mgga},Val{:hyb_mgga}}, rho::ROCArray{Float64};
                         sigma::ROCArray{Float64},
                         tau::OptROCArray=C_NULL,
                         lapl::OptROCArray=C_NULL,
                         zk::OptROCArray=C_NULL,
                         vrho::OptROCArray=C_NULL,
                         vsigma::OptROCArray=C_NULL,
                         vlapl::OptROCArray=C_NULL,
                         vtau::OptROCArray=C_NULL,
                         v2rho2::OptROCArray=C_NULL,
                         v2rhosigma::OptROCArray=C_NULL,
                         v2rholapl::OptROCArray=C_NULL,
                         v2rhotau::OptROCArray=C_NULL,
                         v2sigma2::OptROCArray=C_NULL,
                         v2sigmalapl::OptROCArray=C_NULL,
                         v2sigmatau::OptROCArray=C_NULL,
                         v2lapl2::OptROCArray=C_NULL,
                         v2lapltau::OptROCArray=C_NULL,
                         v2tau2::OptROCArray=C_NULL,
                         v3rho3::OptROCArray=C_NULL,
                         v3rho2sigma::OptROCArray=C_NULL,
                         v3rho2lapl::OptROCArray=C_NULL,
                         v3rho2tau::OptROCArray=C_NULL,
                         v3rhosigma2::OptROCArray=C_NULL,
                         v3rhosigmalapl::OptROCArray=C_NULL,
                         v3rhosigmatau::OptROCArray=C_NULL,
                         v3rholapl2::OptROCArray=C_NULL,
                         v3rholapltau::OptROCArray=C_NULL,
                         v3rhotau2::OptROCArray=C_NULL,
                         v3sigma3::OptROCArray=C_NULL,
                         v3sigma2lapl::OptROCArray=C_NULL,
                         v3sigma2tau::OptROCArray=C_NULL,
                         v3sigmalapl2::OptROCArray=C_NULL,
                         v3sigmalapltau::OptROCArray=C_NULL,
                         v3sigmatau2::OptROCArray=C_NULL,
                         v3lapl3::OptROCArray=C_NULL,
                         v3lapl2tau::OptROCArray=C_NULL,
                         v3lapltau2::OptROCArray=C_NULL,
                         v3tau3::OptROCArray=C_NULL,
                         v4rho4::OptROCArray=C_NULL,
                         v4rho3sigma::OptROCArray=C_NULL,
                         v4rho3lapl::OptROCArray=C_NULL,
                         v4rho3tau::OptROCArray=C_NULL,
                         v4rho2sigma2::OptROCArray=C_NULL,
                         v4rho2sigmalapl::OptROCArray=C_NULL,
                         v4rho2sigmatau::OptROCArray=C_NULL,
                         v4rho2lapl2::OptROCArray=C_NULL,
                         v4rho2lapltau::OptROCArray=C_NULL,
                         v4rho2tau2::OptROCArray=C_NULL,
                         v4rhosigma3::OptROCArray=C_NULL,
                         v4rhosigma2lapl::OptROCArray=C_NULL,
                         v4rhosigma2tau::OptROCArray=C_NULL,
                         v4rhosigmalapl2::OptROCArray=C_NULL,
                         v4rhosigmalapltau::OptROCArray=C_NULL,
                         v4rhosigmatau2::OptROCArray=C_NULL,
                         v4rholapl3::OptROCArray=C_NULL,
                         v4rholapl2tau::OptROCArray=C_NULL,
                         v4rholapltau2::OptROCArray=C_NULL,
                         v4rhotau3::OptROCArray=C_NULL,
                         v4sigma4::OptROCArray=C_NULL,
                         v4sigma3lapl::OptROCArray=C_NULL,
                         v4sigma3tau::OptROCArray=C_NULL,
                         v4sigma2lapl2::OptROCArray=C_NULL,
                         v4sigma2lapltau::OptROCArray=C_NULL,
                         v4sigma2tau2::OptROCArray=C_NULL,
                         v4sigmalapl3::OptROCArray=C_NULL,
                         v4sigmalapl2tau::OptROCArray=C_NULL,
                         v4sigmalapltau2::OptROCArray=C_NULL,
                         v4sigmatau3::OptROCArray=C_NULL,
                         v4lapl4::OptROCArray=C_NULL,
                         v4lapl3tau::OptROCArray=C_NULL,
                         v4lapl2tau2::OptROCArray=C_NULL,
                         v4lapltau3::OptROCArray=C_NULL,
                         v4tau4::OptROCArray=C_NULL)
    if Libxc.needs_tau(func) && tau === C_NULL
        throw(ArgumentError("Functional $(func.identifier) requires tau."))
    end
    if Libxc.needs_laplacian(func) && lapl === C_NULL
        throw(ArgumentError("Functional $(func.identifier) requires lapl."))
    end

    n_p = div(length(rho), func.spin_dimensions.rho)
    pointer = allocate_amdgpufunctional(func)
    @ccall libxc_amdgpu.xc_mgga(
        pointer::Ptr{xc_func_type}, n_p::Csize_t,
        rho::Ptr{Cdouble}, sigma::Ptr{Cdouble},
        lapl::Ptr{Cdouble}, tau::Ptr{Cdouble},
        #
        zk::Ptr{Cdouble}, vrho::Ptr{Cdouble}, vsigma::Ptr{Cdouble},
        vlapl::Ptr{Cdouble}, vtau::Ptr{Cdouble},
        #
        v2rho2::Ptr{Cdouble}, v2rhosigma::Ptr{Cdouble},
        v2rholapl::Ptr{Cdouble}, v2rhotau::Ptr{Cdouble},
        v2sigma2::Ptr{Cdouble}, v2sigmalapl::Ptr{Cdouble},
        v2sigmatau::Ptr{Cdouble}, v2lapl2::Ptr{Cdouble},
        v2lapltau::Ptr{Cdouble}, v2tau2::Ptr{Cdouble},
        v3rho3::Ptr{Cdouble}, v3rho2sigma::Ptr{Cdouble},
        #
        v3rho2lapl::Ptr{Cdouble}, v3rho2tau::Ptr{Cdouble},
        v3rhosigma2::Ptr{Cdouble}, v3rhosigmalapl::Ptr{Cdouble},
        v3rhosigmatau::Ptr{Cdouble}, v3rholapl2::Ptr{Cdouble},
        v3rholapltau::Ptr{Cdouble}, v3rhotau2::Ptr{Cdouble},
        v3sigma3::Ptr{Cdouble}, v3sigma2lapl::Ptr{Cdouble},
        v3sigma2tau::Ptr{Cdouble}, v3sigmalapl2::Ptr{Cdouble},
        v3sigmalapltau::Ptr{Cdouble}, v3sigmatau2::Ptr{Cdouble},
        v3lapl3::Ptr{Cdouble}, v3lapl2tau::Ptr{Cdouble},
        v3lapltau2::Ptr{Cdouble}, v3tau3::Ptr{Cdouble},
        v4rho4::Ptr{Cdouble}, v4rho3sigma::Ptr{Cdouble},
        v4rho3lapl::Ptr{Cdouble},
        #
        v4rho3tau::Ptr{Cdouble}, v4rho2sigma2::Ptr{Cdouble},
        v4rho2sigmalapl::Ptr{Cdouble}, v4rho2sigmatau::Ptr{Cdouble},
        v4rho2lapl2::Ptr{Cdouble}, v4rho2lapltau::Ptr{Cdouble},
        v4rho2tau2::Ptr{Cdouble}, v4rhosigma3::Ptr{Cdouble},
        v4rhosigma2lapl::Ptr{Cdouble}, v4rhosigma2tau::Ptr{Cdouble},
        v4rhosigmalapl2::Ptr{Cdouble}, v4rhosigmalapltau::Ptr{Cdouble},
        v4rhosigmatau2::Ptr{Cdouble}, v4rholapl3::Ptr{Cdouble},
        v4rholapl2tau::Ptr{Cdouble}, v4rholapltau2::Ptr{Cdouble},
        v4rhotau3::Ptr{Cdouble}, v4sigma4::Ptr{Cdouble},
        v4sigma3lapl::Ptr{Cdouble}, v4sigma3tau::Ptr{Cdouble},
        v4sigma2lapl2::Ptr{Cdouble}, v4sigma2lapltau::Ptr{Cdouble},
        v4sigma2tau2::Ptr{Cdouble}, v4sigmalapl3::Ptr{Cdouble},
        v4sigmalapl2tau::Ptr{Cdouble}, v4sigmalapltau2::Ptr{Cdouble},
        v4sigmatau3::Ptr{Cdouble}, v4lapl4::Ptr{Cdouble},
        v4lapl3tau::Ptr{Cdouble}, v4lapl2tau2::Ptr{Cdouble},
        v4lapltau3::Ptr{Cdouble}, v4tau4::Ptr{Cdouble},
    )::Cvoid
    deallocate_amdgpufunctional(pointer)
end

end  # if available
end  # module
