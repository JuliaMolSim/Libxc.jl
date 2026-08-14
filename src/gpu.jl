"""
Return the path to the CUDA version of libxc.

A local path configured via [`set_cuda_libxc_path!`](@ref) takes precedence.
If no local path is configured, fall back to the library provided by
[`Libxc_GPU_jll`](@ref) when available.
"""
const _cuda_libxc_path = @load_preference("libxc_cuda_path",
                                          Libxc_GPU_jll.is_available() ? Libxc_GPU_jll.libxc : nothing)
cuda_libxc_path() = _cuda_libxc_path

"""Is the CUDA version of libxc available on this platform"""
has_cuda() = !isnothing(cuda_libxc_path())

"""
    set_cuda_libxc_path!(path::Union{AbstractString,Nothing})

Configure a local CUDA version of libxc to use instead of the one provided
by [`Libxc_GPU_jll`](@ref). The `path` must point to a shared library
compatible with the CUDA version in use.

Set `path` to `nothing` to remove a previously configured local path and
fall back to [`Libxc_GPU_jll`](@ref).

The preference is stored in `LocalPreferences.toml` and takes effect after
restarting Julia.
"""
function set_cuda_libxc_path!(path::Union{AbstractString,Nothing})
    if isnothing(path)
        @delete_preferences!("libxc_cuda_path")
    else
        isfile(path) || error("Path $path does not exist.")
        @set_preferences!("libxc_cuda_path" => path)
    end
end

"""
Return the path to the AMDGPU (ROCm/HIP) version of libxc.

A local path configured via [`set_amdgpu_libxc_path!`](@ref) must be
provided, as no JLL is available for AMDGPU.
"""
const _amdgpu_libxc_path = @load_preference("libxc_amdgpu_path", nothing)
amdgpu_libxc_path() = _amdgpu_libxc_path

"""Is the AMDGPU version of libxc available on this platform"""
has_amdgpu() = !isnothing(amdgpu_libxc_path())

"""
    set_amdgpu_libxc_path!(path::Union{AbstractString,Nothing})

Configure a local AMDGPU (ROCm/HIP) version of libxc. There is no JLL
for AMDGPU, so an external library must be provided. The `path` must
point to a shared library compatible with the ROCm/HIP version in use.

Set `path` to `nothing` to remove a previously configured local path.

The preference is stored in `LocalPreferences.toml` and takes effect after
restarting Julia.
"""
function set_amdgpu_libxc_path!(path::Union{AbstractString,Nothing})
    if isnothing(path)
        @delete_preferences!("libxc_amdgpu_path")
    else
        isfile(path) || error("Path $path does not exist.")
        @set_preferences!("libxc_amdgpu_path" => path)
    end
end

"""
    @define_gpu_methods(lib, array_t, ptr_t, null_t)

Generate `evaluate!` methods and helper functions for a given GPU backend, using
a shared libxc library given as a path `lib` (a `String`).

- `array_t`: the concrete array type for device arrays (`CuArray{Float64}` or `ROCArray{Float64}`)
- `ptr_t`:   the pointer type for device memory (`CuPtr{Cdouble}` or `Ptr{Cdouble}`)
- `null_t`:  the null sentinel for optional device pointers (`CU_NULL` or `C_NULL`)

It is assumed that !isnothing(lib), to be checked before calling the macro.
"""
macro define_gpu_methods(lib, array_t, ptr_t, null_t)
    esc(quote
        const OptArray = Union{$(array_t), typeof($(null_t))}

        function allocate_gpufunctional(identifier::Symbol, n_spin::Integer)
            n_spin in (1, 2) || error("n_spin needs to be 1 or 2")

            number  = @ccall $(lib).xc_functional_get_number(string(identifier)::Cstring)::Cint
            number == -1 && error("Functional $identifier is not known.")

            pointer = @ccall $(lib).xc_func_alloc()::Ptr{xc_func_type}
            ret = @ccall $(lib).xc_func_init(pointer::Ptr{xc_func_type}, number::Cint,
                                             n_spin::Cint)::Cint
            ret != 0 && error("Something went wrong initialising the functional")

            pointer
        end
        allocate_gpufunctional(func::Functional) = allocate_gpufunctional(func.identifier, func.n_spin)

        function deallocate_gpufunctional(pointer::Ptr{xc_func_type})
            if pointer != C_NULL
                @ccall $(lib).xc_func_end(pointer::Ptr{xc_func_type})::Cvoid
                @ccall $(lib).xc_func_free(pointer::Ptr{xc_func_type})::Cvoid
            end
        end


        function Libxc.evaluate!(func::Functional, ::Union{Val{:lda},Val{:hyb_lda}}, rho::$(array_t);
                                 zk::OptArray=$(null_t),
                                 vrho::OptArray=$(null_t), v2rho2::OptArray=$(null_t),
                                 v3rho3::OptArray=$(null_t), v4rho4::OptArray=$(null_t))
            n_p = div(length(rho), func.spin_dimensions.rho)
            pointer = allocate_gpufunctional(func)
            @ccall $(lib).xc_lda(pointer::Ptr{xc_func_type}, n_p::Csize_t, rho::$(ptr_t),
                                 zk::$(ptr_t), vrho::$(ptr_t), v2rho2::$(ptr_t),
                                 v3rho3::$(ptr_t), v4rho4::$(ptr_t))::Cvoid
            deallocate_gpufunctional(pointer)
        end


        function Libxc.evaluate!(func::Functional, ::Union{Val{:gga},Val{:hyb_gga}}, rho::$(array_t);
                                 sigma::$(array_t), zk::OptArray=$(null_t),
                                 vrho::OptArray=$(null_t), vsigma::OptArray=$(null_t),
                                 v2rho2::OptArray=$(null_t), v2rhosigma::OptArray=$(null_t),
                                 v2sigma2::OptArray=$(null_t),
                                 v3rho3::OptArray=$(null_t), v3rho2sigma::OptArray=$(null_t),
                                 v3rhosigma2::OptArray=$(null_t), v3sigma3::OptArray=$(null_t),
                                 v4rho4::OptArray=$(null_t), v4rho3sigma::OptArray=$(null_t),
                                 v4rho2sigma2::OptArray=$(null_t), v4rhosigma3::OptArray=$(null_t),
                                 v4sigma4::OptArray=$(null_t))
            n_p = div(length(rho), func.spin_dimensions.rho)
            pointer = allocate_gpufunctional(func)
            @ccall $(lib).xc_gga(
                pointer::Ptr{xc_func_type}, n_p::Csize_t, rho::$(ptr_t), sigma::$(ptr_t),
                zk::$(ptr_t),
                vrho::$(ptr_t), vsigma::$(ptr_t), v2rho2::$(ptr_t),
                v2rhosigma::$(ptr_t), v2sigma2::$(ptr_t),
                v3rho3::$(ptr_t), v3rho2sigma::$(ptr_t), v3rhosigma2::$(ptr_t),
                v3sigma3::$(ptr_t),
                v4rho4::$(ptr_t), v4rho3sigma::$(ptr_t), v4rho2sigma2::$(ptr_t),
                v4rhosigma3::$(ptr_t), v4sigma4::$(ptr_t)
            )::Cvoid
            deallocate_gpufunctional(pointer)
        end


        function Libxc.evaluate!(func::Functional, ::Union{Val{:mgga},Val{:hyb_mgga}}, rho::$(array_t);
                                 sigma::$(array_t),
                                 tau::OptArray=$(null_t),
                                 lapl::OptArray=$(null_t),
                                 zk::OptArray=$(null_t),
                                 vrho::OptArray=$(null_t),
                                 vsigma::OptArray=$(null_t),
                                 vlapl::OptArray=$(null_t),
                                 vtau::OptArray=$(null_t),
                                 v2rho2::OptArray=$(null_t),
                                 v2rhosigma::OptArray=$(null_t),
                                 v2rholapl::OptArray=$(null_t),
                                 v2rhotau::OptArray=$(null_t),
                                 v2sigma2::OptArray=$(null_t),
                                 v2sigmalapl::OptArray=$(null_t),
                                 v2sigmatau::OptArray=$(null_t),
                                 v2lapl2::OptArray=$(null_t),
                                 v2lapltau::OptArray=$(null_t),
                                 v2tau2::OptArray=$(null_t),
                                 v3rho3::OptArray=$(null_t),
                                 v3rho2sigma::OptArray=$(null_t),
                                 v3rho2lapl::OptArray=$(null_t),
                                 v3rho2tau::OptArray=$(null_t),
                                 v3rhosigma2::OptArray=$(null_t),
                                 v3rhosigmalapl::OptArray=$(null_t),
                                 v3rhosigmatau::OptArray=$(null_t),
                                 v3rholapl2::OptArray=$(null_t),
                                 v3rholapltau::OptArray=$(null_t),
                                 v3rhotau2::OptArray=$(null_t),
                                 v3sigma3::OptArray=$(null_t),
                                 v3sigma2lapl::OptArray=$(null_t),
                                 v3sigma2tau::OptArray=$(null_t),
                                 v3sigmalapl2::OptArray=$(null_t),
                                 v3sigmalapltau::OptArray=$(null_t),
                                 v3sigmatau2::OptArray=$(null_t),
                                 v3lapl3::OptArray=$(null_t),
                                 v3lapl2tau::OptArray=$(null_t),
                                 v3lapltau2::OptArray=$(null_t),
                                 v3tau3::OptArray=$(null_t),
                                 v4rho4::OptArray=$(null_t),
                                 v4rho3sigma::OptArray=$(null_t),
                                 v4rho3lapl::OptArray=$(null_t),
                                 v4rho3tau::OptArray=$(null_t),
                                 v4rho2sigma2::OptArray=$(null_t),
                                 v4rho2sigmalapl::OptArray=$(null_t),
                                 v4rho2sigmatau::OptArray=$(null_t),
                                 v4rho2lapl2::OptArray=$(null_t),
                                 v4rho2lapltau::OptArray=$(null_t),
                                 v4rho2tau2::OptArray=$(null_t),
                                 v4rhosigma3::OptArray=$(null_t),
                                 v4rhosigma2lapl::OptArray=$(null_t),
                                 v4rhosigma2tau::OptArray=$(null_t),
                                 v4rhosigmalapl2::OptArray=$(null_t),
                                 v4rhosigmalapltau::OptArray=$(null_t),
                                 v4rhosigmatau2::OptArray=$(null_t),
                                 v4rholapl3::OptArray=$(null_t),
                                 v4rholapl2tau::OptArray=$(null_t),
                                 v4rholapltau2::OptArray=$(null_t),
                                 v4rhotau3::OptArray=$(null_t),
                                 v4sigma4::OptArray=$(null_t),
                                 v4sigma3lapl::OptArray=$(null_t),
                                 v4sigma3tau::OptArray=$(null_t),
                                 v4sigma2lapl2::OptArray=$(null_t),
                                 v4sigma2lapltau::OptArray=$(null_t),
                                 v4sigma2tau2::OptArray=$(null_t),
                                 v4sigmalapl3::OptArray=$(null_t),
                                 v4sigmalapl2tau::OptArray=$(null_t),
                                 v4sigmalapltau2::OptArray=$(null_t),
                                 v4sigmatau3::OptArray=$(null_t),
                                 v4lapl4::OptArray=$(null_t),
                                 v4lapl3tau::OptArray=$(null_t),
                                 v4lapl2tau2::OptArray=$(null_t),
                                 v4lapltau3::OptArray=$(null_t),
                                 v4tau4::OptArray=$(null_t))
            if Libxc.needs_tau(func) && tau === $(null_t)
                throw(ArgumentError("Functional $(func.identifier) requires tau."))
            end
            if Libxc.needs_laplacian(func) && lapl === $(null_t)
                throw(ArgumentError("Functional $(func.identifier) requires lapl."))
            end

            n_p = div(length(rho), func.spin_dimensions.rho)
            pointer = allocate_gpufunctional(func)
            @ccall $(lib).xc_mgga(
                pointer::Ptr{xc_func_type}, n_p::Csize_t,
                rho::$(ptr_t), sigma::$(ptr_t),
                lapl::$(ptr_t), tau::$(ptr_t),
                #
                zk::$(ptr_t), vrho::$(ptr_t), vsigma::$(ptr_t),
                vlapl::$(ptr_t), vtau::$(ptr_t),
                #
                v2rho2::$(ptr_t), v2rhosigma::$(ptr_t),
                v2rholapl::$(ptr_t), v2rhotau::$(ptr_t),
                v2sigma2::$(ptr_t), v2sigmalapl::$(ptr_t),
                v2sigmatau::$(ptr_t), v2lapl2::$(ptr_t),
                v2lapltau::$(ptr_t), v2tau2::$(ptr_t),
                v3rho3::$(ptr_t), v3rho2sigma::$(ptr_t),
                #
                v3rho2lapl::$(ptr_t), v3rho2tau::$(ptr_t),
                v3rhosigma2::$(ptr_t), v3rhosigmalapl::$(ptr_t),
                v3rhosigmatau::$(ptr_t), v3rholapl2::$(ptr_t),
                v3rholapltau::$(ptr_t), v3rhotau2::$(ptr_t),
                v3sigma3::$(ptr_t), v3sigma2lapl::$(ptr_t),
                v3sigma2tau::$(ptr_t), v3sigmalapl2::$(ptr_t),
                v3sigmalapltau::$(ptr_t), v3sigmatau2::$(ptr_t),
                v3lapl3::$(ptr_t), v3lapl2tau::$(ptr_t),
                v3lapltau2::$(ptr_t), v3tau3::$(ptr_t),
                v4rho4::$(ptr_t), v4rho3sigma::$(ptr_t),
                v4rho3lapl::$(ptr_t),
                #
                v4rho3tau::$(ptr_t), v4rho2sigma2::$(ptr_t),
                v4rho2sigmalapl::$(ptr_t), v4rho2sigmatau::$(ptr_t),
                v4rho2lapl2::$(ptr_t), v4rho2lapltau::$(ptr_t),
                v4rho2tau2::$(ptr_t), v4rhosigma3::$(ptr_t),
                v4rhosigma2lapl::$(ptr_t), v4rhosigma2tau::$(ptr_t),
                v4rhosigmalapl2::$(ptr_t), v4rhosigmalapltau::$(ptr_t),
                v4rhosigmatau2::$(ptr_t), v4rholapl3::$(ptr_t),
                v4rholapl2tau::$(ptr_t), v4rholapltau2::$(ptr_t),
                v4rhotau3::$(ptr_t), v4sigma4::$(ptr_t),
                v4sigma3lapl::$(ptr_t), v4sigma3tau::$(ptr_t),
                v4sigma2lapl2::$(ptr_t), v4sigma2lapltau::$(ptr_t),
                v4sigma2tau2::$(ptr_t), v4sigmalapl3::$(ptr_t),
                v4sigmalapl2tau::$(ptr_t), v4sigmalapltau2::$(ptr_t),
                v4sigmatau3::$(ptr_t), v4lapl4::$(ptr_t),
                v4lapl3tau::$(ptr_t), v4lapl2tau2::$(ptr_t),
                v4lapltau3::$(ptr_t), v4tau4::$(ptr_t),
            )::Cvoid
            deallocate_gpufunctional(pointer)
        end
    end)
end
