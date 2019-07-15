mutable struct FuncReferType
    ref::Ptr{UInt8}
    doi::Ptr{UInt8}
    bibtex::Ptr{UInt8}
end

xc_func_reference_get_ref(frt::Ref{FuncReferType}) =
    ccall((:xc_func_reference_get_ref, libxc), Ptr{UInt8}, (Ref{FuncReferType},), frt)
xc_func_reference_get_doi(frt::Ref{FuncReferType}) =
    ccall((:xc_func_reference_get_doi, libxc), Ptr{UInt8}, (Ref{FuncReferType},), frt)
xc_func_reference_get_bibtex(frt::Ref{FuncReferType}) =
    ccall((:xc_func_reference_get_bibtex, libxc), Ptr{UInt8}, (Ref{FuncReferType},), frt)

mutable struct FuncParamsType
    value::Float64
    description::Ptr{UInt8}
end

const MAX_REFERENCES = 5

mutable struct XCFuncInfoType
    number::Cint
    kind::Cint
    name::Ptr{UInt8}
    family::Cint
    refs::NTuple{MAX_REFERENCES, Ref{FuncReferType}}

    flags::Cint

    dens_threshold::Float64

    n_ext_params::Cint
    ext_params::Ref{FuncParamsType}
    set_ext_params::Ptr{Cvoid}

    init::Ptr{Cvoid}
    end_::Ptr{Cvoid}
    lda::Ptr{Cvoid}
    gga::Ptr{Cvoid}
    mgga::Ptr{Cvoid}
end

xc_func_info_get_number(info::Ref{XCFuncInfoType}) =
    ccall( (:xc_func_info_get_number, libxc), Cint, (Ref{XCFuncInfoType},), info)
xc_func_info_get_kind(info::Ref{XCFuncInfoType}) =
    ccall( (:xc_func_info_get_kind, libxc), Cint, (Ref{XCFuncInfoType},), info)
xc_func_info_get_name(info::Ref{XCFuncInfoType}) = unsafe_string(
    ccall( (:xc_func_info_get_name, libxc), Ptr{UInt8}, (Ref{XCFuncInfoType},), info) )
xc_func_info_get_family(info::Ref{XCFuncInfoType}) =
    ccall( (:xc_func_info_get_family, libxc), Cint, (Ref{XCFuncInfoType},), info)
xc_func_info_get_flags(info::Ref{XCFuncInfoType}) =
    ccall( (:xc_func_info_get_flags, libxc), Cint, (Ref{XCFuncInfoType},), info)
xc_func_info_get_references(info::Ref{XCFuncInfoType}, number::Int64) =
    ccall( (:xc_func_info_get_references, libxc), Ref{FuncReferType}, (Ref{XCFuncInfoType},Cint), info, Cint(number))
xc_func_info_get_n_ext_params(info::Ref{XCFuncInfoType}) =
    ccall( (:xc_func_info_get_n_ext_params, libxc), Cint, (Ref{XCFuncInfoType},), info)
xc_func_info_get_ext_params_description(info::Ref{XCFuncInfoType}, number::Int64) = unsafe_string(
    ccall( (:xc_func_info_get_ext_params_description, libxc), Ref{FuncReferType}, (Ref{XCFuncInfoType},Cint), info, Cint(number)) )
xc_func_info_get_ext_params_default_value(info::Ref{XCFuncInfoType}, number::Int64) =
    ccall( (:xc_func_info_get_ext_params_default_value, libxc), Float64, (Ref{XCFuncInfoType},Cint), info, Cint(number))

mutable struct _XCFuncType
    # info::Ref{XCFuncInfoType}
    nspin::Cint
    n_func_aux::Cint
    # func_aux::Ptr{Ref{XCFuncType}}
    mix_coef::Ptr{Float64}

    cam_omega::Float64
    cam_alpha::Float64
    cam_beta::Float64

    nlc_b::Float64
    nlc_C::Float64

    n_rho::Cint
    n_sigma::Cint
    n_tau::Cint
    n_lapl::Cint

    n_zk::Cint

    n_vrho::Cint
    n_vsigma::Cint
    n_vtau::Cint
    n_vlapl::Cint

    n_v2rho2::Cint
    n_v2sigma2::Cint
    n_v2tau2::Cint
    n_v2lapl2::Cint
    n_v2rhosigma::Cint
    n_v2rhotau::Cint
    n_v2rholapl::Cint
    n_v2sigmatau::Cint
    n_v2sigmalapl::Cint
    n_v2lapltau::Cint

    n_v3rho3::Cint
    n_v3rho2sigma::Cint
    n_v3rhosigma2::Cint
    n_v3sigma3::Cint

    params::Ptr{Cvoid}
    dens_threshold::Float64
end

mutable struct XCFuncType
end

xc_func_alloc() = ccall( (:xc_func_alloc, libxc), Ptr{XCFuncType}, () )
xc_func_init(p::Ptr{XCFuncType}, functional::Integer, nspin::Integer) =
    ccall( (:xc_func_init, libxc), Cint, (Ptr{XCFuncType}, Cint, Cint), p, functional, nspin)
xc_func_end(p::Ptr{XCFuncType}) = ccall( (:xc_func_end, libxc), Cvoid, (Ptr{XCFuncType},), p)
xc_func_free(p::Ptr{XCFuncType}) = ccall( (:xc_func_free, libxc), Cvoid, (Ptr{XCFuncType},), p)
xc_func_get_info(p::Ptr{XCFuncType}) = ccall( (:xc_func_get_info, libxc), Ptr{XCFuncInfoType}, (Ref{XCFuncType},), p )
xc_func_set_dens_threshold(p::Ptr{XCFuncType}, dens_threshold::Float64) = ccall( (:xc_func_set_dens_threshold, libxc), Cvoid, (Ptr{XCFuncType}, Float64), p, dens_threshold)
xc_func_set_ext_params(p::Ptr{XCFuncType}, ext_params::Ptr{Float64}) = ccall( (:xc_func_set_ext_params, libxc), Cvoid, (Ptr{XCFuncType}, Ptr{Float64}), p, ext_params)

######################################################################
##  LDA-xc
######################################################################

xc_lda!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, zk::Array{Float64, 1}, vrho::Array{Float64, 1}, v2rho2::Array{Float64, 1}, v3rho3::Array{Float64, 1}) =
    ccall( (:xc_lda, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), p, np, rho, zk, vrho, v2rho2, v3rho3)
xc_lda_exc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, zk::Array{Float64, 1}) =
    ccall( (:xc_lda_exc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64}), p, np, rho, zk)
xc_lda_exc_vxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, zk::Array{Float64, 1}, vrho::Array{Float64, 1}) =
    ccall( (:xc_lda_exc_vxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}), p, np, rho, zk, vrho)
xc_lda_vxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, vrho::Array{Float64, 1}) =
    ccall( (:xc_lda_vxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64}), p, np, rho, vrho)
xc_lda_fxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, v2rho2::Array{Float64, 1}) =
    ccall( (:xc_lda_fxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64}), p, np, rho, v2rho2)
xc_lda_kxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, v3rho3::Array{Float64, 1}) =
    ccall( (:xc_lda_kxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64}), p, np, rho, v3rho3)

######################################################################
##  GGA-xc
######################################################################

xc_gga!(p::Ptr{XCFuncType}, np::Int,
        rho::Array{Float64, 1}, sigma::Array{Float64, 1},
        zk::Array{Float64, 1}, vrho::Array{Float64, 1}, vsigma::Array{Float64, 1},
        v2rho2::Array{Float64, 1}, v2rhosigma::Array{Float64, 1}, v2sigma2::Array{Float64, 1},
        v3rho3::Array{Float64, 1}, v3rho2sigma::Array{Float64, 1}, v3rhosigma2::Array{Float64, 1}, v3sigma3::Array{Float64, 1}) =
    ccall( (:xc_gga, libxc), Cvoid, (Ptr{XCFuncType}, Cint,
                                     Ptr{Float64}, Ptr{Float64},
                                     Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
                                     Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
                                     Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
                                     p, np,
                                     rho, sigma,
                                     zk, vrho, vsigma,
                                     v2rho2, v2rhosigma, v2sigma2,
                                     v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)

xc_gga_exc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, sigma::Array{Float64, 1},
            zk::Array{Float64, 1}) =
    ccall( (:xc_gga_exc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                         Ptr{Float64}),
                                         p, np, rho, sigma,
                                         zk)

xc_gga_exc_vxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, sigma::Array{Float64, 1},
                zk::Array{Float64, 1}, vrho::Array{Float64, 1}, vsigma::Array{Float64, 1}) =
    ccall( (:xc_gga_exc_vxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                             Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
                                             p, np, rho, sigma,
                                             zk, vrho, vsigma)

xc_gga_vxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, sigma::Array{Float64, 1},
            vrho::Array{Float64, 1}, vsigma::Array{Float64, 1}) =
    ccall( (:xc_gga_vxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                         Ptr{Float64}, Ptr{Float64}),
                                         p, np, rho, sigma,
                                         vrho, vsigma)

xc_gga_fxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, sigma::Array{Float64, 1},
            v2rho2::Array{Float64, 1}, v2rhosigma::Array{Float64, 1}, v2sigma2::Array{Float64, 1}) =
    ccall( (:xc_gga_fxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                         Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
                                         p, np, rho, sigma,
                                         v2rho2, v2rhosigma, v2sigma2)

xc_gga_kxc!(p::Ptr{XCFuncType}, np::Int, rho::Array{Float64, 1}, sigma::Array{Float64, 1},
            v3rho3::Array{Float64, 1}, v3rho2sigma::Array{Float64, 1}, v3rhosigma2::Array{Float64, 1}, v3sigma3::Array{Float64, 1}) =
    ccall( (:xc_gga_kxc, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                         Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
                                         p, np, rho, sigma,
                                         v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)

# TODO
#
# void xc_gga_lb_modified  (const xc_func_type *p, int np, const double *rho, const double *sigma,
# 			   double r, double *vrho);
#
# double xc_gga_ak13_get_asymptotic (double homo);
#
# double xc_hyb_exx_coef(const xc_func_type *p);
# void  xc_hyb_cam_coef(const xc_func_type *p, double *omega, double *alpha, double *beta);
# void  xc_nlc_coef(const xc_func_type *p, double *nlc_b, double *nlc_C);

######################################################################
##  meta GGA-xc
######################################################################
# void xc_mgga        (const xc_func_type *p, int np,
# 		      const double *rho, const double *sigma, const double *lapl, const double *tau,
# 		      double *zk, double *vrho, double *vsigma, double *vlapl, double *vtau,
# 		      double *v2rho2, double *v2sigma2, double *v2lapl2, double *v2tau2,
# 		      double *v2rhosigma, double *v2rholapl, double *v2rhotau,
# 		      double *v2sigmalapl, double *v2sigmatau, double *v2lapltau);
# void xc_mgga_exc    (const xc_func_type *p, int np,
# 		      const double *rho, const double *sigma, const double *lapl, const double *tau,
# 		      double *zk);
# void xc_mgga_exc_vxc(const xc_func_type *p, int np,
# 		      const double *rho, const double *sigma, const double *lapl, const double *tau,
# 		      double *zk, double *vrho, double *vsigma, double *vlapl, double *vtau);
# void xc_mgga_vxc    (const xc_func_type *p, int np,
# 		      const double *rho, const double *sigma, const double *lapl, const double *tau,
# 		      double *vrho, double *vsigma, double *vlapl, double *vtau);
# void xc_mgga_fxc    (const xc_func_type *p, int np,
# 		      const double *rho, const double *sigma, const double *lapl, const double *tau,
# 		      double *v2rho2, double *v2sigma2, double *v2lapl2, double *v2tau2,
# 		      double *v2rhosigma, double *v2rholapl, double *v2rhotau,
# 		      double *v2sigmalapl, double *v2sigmatau, double *v2lapltau);

######################################################################
# /* Functionals that are defined as mixtures of others */
######################################################################

# void xc_mix_func
#   (const xc_func_type *func, int np,
#    const double *rho, const double *sigma, const double *lapl, const double *tau,
#    double *zk, double *vrho, double *vsigma, double *vlapl, double *vtau,
#    double *v2rho2, double *v2sigma2, double *v2lapl2, double *v2tau2,
#    double *v2rhosigma, double *v2rholapl, double *v2rhotau,
#    double *v2sigmalapl, double *v2sigmatau, double *v2lapltau);
