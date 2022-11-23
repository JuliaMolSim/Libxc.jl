# Julia wrapper for header: xc.h
# Automatically generated using Clang.jl


function xc_reference()
    ccall((:xc_reference, libxc), Ptr{Cchar}, ())
end

function xc_reference_doi()
    ccall((:xc_reference_doi, libxc), Ptr{Cchar}, ())
end

function xc_reference_key()
    ccall((:xc_reference_key, libxc), Ptr{Cchar}, ())
end

function xc_version(major, minor, micro)
    ccall((:xc_version, libxc), Cvoid, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), major, minor, micro)
end

function xc_version_string()
    ccall((:xc_version_string, libxc), Ptr{Cchar}, ())
end

function xc_func_reference_get_ref(reference)
    ccall((:xc_func_reference_get_ref, libxc), Ptr{Cchar}, (Ptr{func_reference_type},), reference)
end

function xc_func_reference_get_doi(reference)
    ccall((:xc_func_reference_get_doi, libxc), Ptr{Cchar}, (Ptr{func_reference_type},), reference)
end

function xc_func_reference_get_bibtex(reference)
    ccall((:xc_func_reference_get_bibtex, libxc), Ptr{Cchar}, (Ptr{func_reference_type},), reference)
end

function xc_func_reference_get_key(reference)
    ccall((:xc_func_reference_get_key, libxc), Ptr{Cchar}, (Ptr{func_reference_type},), reference)
end

function xc_func_info_get_number(info)
    ccall((:xc_func_info_get_number, libxc), Cint, (Ptr{xc_func_info_type},), info)
end

function xc_func_info_get_kind(info)
    ccall((:xc_func_info_get_kind, libxc), Cint, (Ptr{xc_func_info_type},), info)
end

function xc_func_info_get_name(info)
    ccall((:xc_func_info_get_name, libxc), Ptr{Cchar}, (Ptr{xc_func_info_type},), info)
end

function xc_func_info_get_family(info)
    ccall((:xc_func_info_get_family, libxc), Cint, (Ptr{xc_func_info_type},), info)
end

function xc_func_info_get_flags(info)
    ccall((:xc_func_info_get_flags, libxc), Cint, (Ptr{xc_func_info_type},), info)
end

function xc_func_info_get_references(info, number)
    ccall((:xc_func_info_get_references, libxc), Ptr{func_reference_type}, (Ptr{xc_func_info_type}, Cint), info, number)
end

function xc_func_info_get_n_ext_params(info)
    ccall((:xc_func_info_get_n_ext_params, libxc), Cint, (Ptr{xc_func_info_type},), info)
end

function xc_func_info_get_ext_params_name(p, number)
    ccall((:xc_func_info_get_ext_params_name, libxc), Ptr{Cchar}, (Ptr{xc_func_info_type}, Cint), p, number)
end

function xc_func_info_get_ext_params_description(info, number)
    ccall((:xc_func_info_get_ext_params_description, libxc), Ptr{Cchar}, (Ptr{xc_func_info_type}, Cint), info, number)
end

function xc_func_info_get_ext_params_default_value(info, number)
    ccall((:xc_func_info_get_ext_params_default_value, libxc), Cdouble, (Ptr{xc_func_info_type}, Cint), info, number)
end

function xc_functional_get_number(name)
    ccall((:xc_functional_get_number, libxc), Cint, (Ptr{Cchar},), name)
end

function xc_functional_get_name(number)
    ccall((:xc_functional_get_name, libxc), Ptr{Cchar}, (Cint,), number)
end

function xc_family_from_id(id, family, number)
    ccall((:xc_family_from_id, libxc), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), id, family, number)
end

function xc_number_of_functionals()
    ccall((:xc_number_of_functionals, libxc), Cint, ())
end

function xc_maximum_name_length()
    ccall((:xc_maximum_name_length, libxc), Cint, ())
end

function xc_available_functional_numbers(list)
    ccall((:xc_available_functional_numbers, libxc), Cvoid, (Ptr{Cint},), list)
end

function xc_available_functional_numbers_by_name(list)
    ccall((:xc_available_functional_numbers_by_name, libxc), Cvoid, (Ptr{Cint},), list)
end

function xc_available_functional_names(list)
    ccall((:xc_available_functional_names, libxc), Cvoid, (Ptr{Ptr{Cchar}},), list)
end

function xc_func_alloc()
    ccall((:xc_func_alloc, libxc), Ptr{xc_func_type}, ())
end

function xc_func_init(p, functional, nspin)
    ccall((:xc_func_init, libxc), Cint, (Ptr{xc_func_type}, Cint, Cint), p, functional, nspin)
end

function xc_func_end(p)
    ccall((:xc_func_end, libxc), Cvoid, (Ptr{xc_func_type},), p)
end

function xc_func_free(p)
    ccall((:xc_func_free, libxc), Cvoid, (Ptr{xc_func_type},), p)
end

function xc_func_get_info(p)
    ccall((:xc_func_get_info, libxc), Ptr{xc_func_info_type}, (Ptr{xc_func_type},), p)
end

function xc_func_set_dens_threshold(p, t_dens)
    ccall((:xc_func_set_dens_threshold, libxc), Cvoid, (Ptr{xc_func_type}, Cdouble), p, t_dens)
end

function xc_func_set_zeta_threshold(p, t_zeta)
    ccall((:xc_func_set_zeta_threshold, libxc), Cvoid, (Ptr{xc_func_type}, Cdouble), p, t_zeta)
end

function xc_func_set_sigma_threshold(p, t_sigma)
    ccall((:xc_func_set_sigma_threshold, libxc), Cvoid, (Ptr{xc_func_type}, Cdouble), p, t_sigma)
end

function xc_func_set_tau_threshold(p, t_tau)
    ccall((:xc_func_set_tau_threshold, libxc), Cvoid, (Ptr{xc_func_type}, Cdouble), p, t_tau)
end

function xc_func_set_ext_params(p, ext_params)
    ccall((:xc_func_set_ext_params, libxc), Cvoid, (Ptr{xc_func_type}, Ptr{Cdouble}), p, ext_params)
end

function xc_func_set_ext_params_name(p, name, par)
    ccall((:xc_func_set_ext_params_name, libxc), Cvoid, (Ptr{xc_func_type}, Ptr{Cchar}, Cdouble), p, name, par)
end

function xc_lda_new(p, order, np, rho, out)
    ccall((:xc_lda_new, libxc), Cvoid, (Ptr{xc_func_type}, Cint, Csize_t, Ptr{Cdouble}, Ptr{xc_lda_out_params}), p, order, np, rho, out)
end

function xc_gga_new(p, order, np, rho, sigma, out)
    ccall((:xc_gga_new, libxc), Cvoid, (Ptr{xc_func_type}, Cint, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{xc_gga_out_params}), p, order, np, rho, sigma, out)
end

function xc_lda(p, np, rho, zk, vrho, v2rho2, v3rho3, v4rho4)
    ccall((:xc_lda, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, zk, vrho, v2rho2, v3rho3, v4rho4)
end

function xc_gga(p, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3, v4rho4, v4rho3sigma, v4rho2sigma2, v4rhosigma3, v4sigma4)
    ccall((:xc_gga, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3, v4rho4, v4rho3sigma, v4rho2sigma2, v4rhosigma3, v4sigma4)
end

function xc_mgga(p, np, rho, sigma, lapl_rho, tau, zk, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3, v4rho4, v4rho3sigma, v4rho3lapl, v4rho3tau, v4rho2sigma2, v4rho2sigmalapl, v4rho2sigmatau, v4rho2lapl2, v4rho2lapltau, v4rho2tau2, v4rhosigma3, v4rhosigma2lapl, v4rhosigma2tau, v4rhosigmalapl2, v4rhosigmalapltau, v4rhosigmatau2, v4rholapl3, v4rholapl2tau, v4rholapltau2, v4rhotau3, v4sigma4, v4sigma3lapl, v4sigma3tau, v4sigma2lapl2, v4sigma2lapltau, v4sigma2tau2, v4sigmalapl3, v4sigmalapl2tau, v4sigmalapltau2, v4sigmatau3, v4lapl4, v4lapl3tau, v4lapl2tau2, v4lapltau3, v4tau4)
    ccall((:xc_mgga, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl_rho, tau, zk, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3, v4rho4, v4rho3sigma, v4rho3lapl, v4rho3tau, v4rho2sigma2, v4rho2sigmalapl, v4rho2sigmatau, v4rho2lapl2, v4rho2lapltau, v4rho2tau2, v4rhosigma3, v4rhosigma2lapl, v4rhosigma2tau, v4rhosigmalapl2, v4rhosigmalapltau, v4rhosigmatau2, v4rholapl3, v4rholapl2tau, v4rholapltau2, v4rhotau3, v4sigma4, v4sigma3lapl, v4sigma3tau, v4sigma2lapl2, v4sigma2lapltau, v4sigma2tau2, v4sigmalapl3, v4sigmalapl2tau, v4sigmalapltau2, v4sigmatau3, v4lapl4, v4lapl3tau, v4lapl2tau2, v4lapltau3, v4tau4)
end

function xc_lda_exc(p, np, rho, zk)
    ccall((:xc_lda_exc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, zk)
end

function xc_gga_exc(p, np, rho, sigma, zk)
    ccall((:xc_gga_exc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, zk)
end

function xc_mgga_exc(p, np, rho, sigma, lapl, tau, zk)
    ccall((:xc_mgga_exc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, zk)
end

function xc_lda_exc_vxc(p, np, rho, zk, vrho)
    ccall((:xc_lda_exc_vxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, zk, vrho)
end

function xc_gga_exc_vxc(p, np, rho, sigma, zk, vrho, vsigma)
    ccall((:xc_gga_exc_vxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, zk, vrho, vsigma)
end

function xc_mgga_exc_vxc(p, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau)
    ccall((:xc_mgga_exc_vxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau)
end

function xc_lda_vxc(p, np, rho, vrho)
    ccall((:xc_lda_vxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, vrho)
end

function xc_gga_vxc(p, np, rho, sigma, vrho, vsigma)
    ccall((:xc_gga_vxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, vrho, vsigma)
end

function xc_mgga_vxc(p, np, rho, sigma, lapl, tau, vrho, vsigma, vlapl, vtau)
    ccall((:xc_mgga_vxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, vrho, vsigma, vlapl, vtau)
end

function xc_lda_exc_vxc_fxc(p, np, rho, zk, vrho, v2rho2)
    ccall((:xc_lda_exc_vxc_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, zk, vrho, v2rho2)
end

function xc_gga_exc_vxc_fxc(p, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2)
    ccall((:xc_gga_exc_vxc_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2)
end

function xc_mgga_exc_vxc_fxc(p, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2)
    ccall((:xc_mgga_exc_vxc_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2)
end

function xc_lda_vxc_fxc(p, np, rho, vrho, v2rho2)
    ccall((:xc_lda_vxc_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, vrho, v2rho2)
end

function xc_gga_vxc_fxc(p, np, rho, sigma, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2)
    ccall((:xc_gga_vxc_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2)
end

function xc_mgga_vxc_fxc(p, np, rho, sigma, lapl, tau, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2)
    ccall((:xc_mgga_vxc_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2)
end

function xc_lda_fxc(p, np, rho, v2rho2)
    ccall((:xc_lda_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, v2rho2)
end

function xc_gga_fxc(p, np, rho, sigma, v2rho2, v2rhosigma, v2sigma2)
    ccall((:xc_gga_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, v2rho2, v2rhosigma, v2sigma2)
end

function xc_mgga_fxc(p, np, rho, sigma, lapl, tau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2)
    ccall((:xc_mgga_fxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2)
end

function xc_lda_exc_vxc_fxc_kxc(p, np, rho, zk, vrho, v2rho2, v3rho3)
    ccall((:xc_lda_exc_vxc_fxc_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, zk, vrho, v2rho2, v3rho3)
end

function xc_gga_exc_vxc_fxc_kxc(p, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)
    ccall((:xc_gga_exc_vxc_fxc_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)
end

function xc_mgga_exc_vxc_fxc_kxc(p, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3)
    ccall((:xc_mgga_exc_vxc_fxc_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3)
end

function xc_lda_vxc_fxc_kxc(p, np, rho, vrho, v2rho2, v3rho3)
    ccall((:xc_lda_vxc_fxc_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, vrho, v2rho2, v3rho3)
end

function xc_gga_vxc_fxc_kxc(p, np, rho, sigma, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)
    ccall((:xc_gga_vxc_fxc_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)
end

function xc_mgga_vxc_fxc_kxc(p, np, rho, sigma, lapl, tau, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3)
    ccall((:xc_mgga_vxc_fxc_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, vrho, vsigma, vlapl, vtau, v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl, v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3)
end

function xc_lda_kxc(p, np, rho, v3rho3)
    ccall((:xc_lda_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, v3rho3)
end

function xc_gga_kxc(p, np, rho, sigma, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)
    ccall((:xc_gga_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3)
end

function xc_mgga_kxc(p, np, rho, sigma, lapl, tau, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3)
    ccall((:xc_mgga_kxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, v3rho3, v3rho2sigma, v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau, v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl, v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3, v3lapl2tau, v3lapltau2, v3tau3)
end

function xc_lda_lxc(p, np, rho, v4rho4)
    ccall((:xc_lda_lxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, v4rho4)
end

function xc_gga_lxc(p, np, rho, sigma, v4rho4, v4rho3sigma, v4rho2sigma2, v4rhosigma3, v4sigma4)
    ccall((:xc_gga_lxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, v4rho4, v4rho3sigma, v4rho2sigma2, v4rhosigma3, v4sigma4)
end

function xc_mgga_lxc(p, np, rho, sigma, lapl, tau, v4rho4, v4rho3sigma, v4rho3lapl, v4rho3tau, v4rho2sigma2, v4rho2sigmalapl, v4rho2sigmatau, v4rho2lapl2, v4rho2lapltau, v4rho2tau2, v4rhosigma3, v4rhosigma2lapl, v4rhosigma2tau, v4rhosigmalapl2, v4rhosigmalapltau, v4rhosigmatau2, v4rholapl3, v4rholapl2tau, v4rholapltau2, v4rhotau3, v4sigma4, v4sigma3lapl, v4sigma3tau, v4sigma2lapl2, v4sigma2lapltau, v4sigma2tau2, v4sigmalapl3, v4sigmalapl2tau, v4sigmalapltau2, v4sigmatau3, v4lapl4, v4lapl3tau, v4lapl2tau2, v4lapltau3, v4tau4)
    ccall((:xc_mgga_lxc, libxc), Cvoid, (Ptr{xc_func_type}, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, np, rho, sigma, lapl, tau, v4rho4, v4rho3sigma, v4rho3lapl, v4rho3tau, v4rho2sigma2, v4rho2sigmalapl, v4rho2sigmatau, v4rho2lapl2, v4rho2lapltau, v4rho2tau2, v4rhosigma3, v4rhosigma2lapl, v4rhosigma2tau, v4rhosigmalapl2, v4rhosigmalapltau, v4rhosigmatau2, v4rholapl3, v4rholapl2tau, v4rholapltau2, v4rhotau3, v4sigma4, v4sigma3lapl, v4sigma3tau, v4sigma2lapl2, v4sigma2lapltau, v4sigma2tau2, v4sigmalapl3, v4sigmalapl2tau, v4sigmalapltau2, v4sigmatau3, v4lapl4, v4lapl3tau, v4lapl2tau2, v4lapltau3, v4tau4)
end

function xc_gga_ak13_get_asymptotic(homo)
    ccall((:xc_gga_ak13_get_asymptotic, libxc), Cdouble, (Cdouble,), homo)
end

function xc_gga_ak13_pars_get_asymptotic(homo, ext_params)
    ccall((:xc_gga_ak13_pars_get_asymptotic, libxc), Cdouble, (Cdouble, Ptr{Cdouble}), homo, ext_params)
end

function xc_hyb_exx_coef(p)
    ccall((:xc_hyb_exx_coef, libxc), Cdouble, (Ptr{xc_func_type},), p)
end

function xc_hyb_cam_coef(p, omega, alpha, beta)
    ccall((:xc_hyb_cam_coef, libxc), Cvoid, (Ptr{xc_func_type}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), p, omega, alpha, beta)
end

function xc_nlc_coef(p, nlc_b, nlc_C)
    ccall((:xc_nlc_coef, libxc), Cvoid, (Ptr{xc_func_type}, Ptr{Cdouble}, Ptr{Cdouble}), p, nlc_b, nlc_C)
end

function xc_num_aux_funcs(p)
    ccall((:xc_num_aux_funcs, libxc), Cint, (Ptr{xc_func_type},), p)
end

function xc_aux_func_ids(p, ids)
    ccall((:xc_aux_func_ids, libxc), Cvoid, (Ptr{xc_func_type}, Ptr{Cint}), p, ids)
end

function xc_aux_func_weights(p, weights)
    ccall((:xc_aux_func_weights, libxc), Cvoid, (Ptr{xc_func_type}, Ptr{Cdouble}), p, weights)
end

