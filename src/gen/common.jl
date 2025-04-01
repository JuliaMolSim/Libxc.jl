struct func_reference_type
    ref::Ptr{Cchar}
    doi::Ptr{Cchar}
    bibtex::Ptr{Cchar}
    key::Ptr{Cchar}
end

struct func_params_type
    n::Cint
    names::Ptr{Ptr{Cchar}}
    descriptions::Ptr{Ptr{Cchar}}
    values::Ptr{Cdouble}
    set::Ptr{Cvoid}
end

struct xc_lda_out_params
    zk::Ptr{Cdouble}
    vrho::Ptr{Cdouble}
    v2rho2::Ptr{Cdouble}
    v3rho3::Ptr{Cdouble}
    v4rho4::Ptr{Cdouble}
end

struct xc_gga_out_params
    zk::Ptr{Cdouble}
    vrho::Ptr{Cdouble}
    vsigma::Ptr{Cdouble}
    v2rho2::Ptr{Cdouble}
    v2rhosigma::Ptr{Cdouble}
    v2sigma2::Ptr{Cdouble}
    v3rho3::Ptr{Cdouble}
    v3rho2sigma::Ptr{Cdouble}
    v3rhosigma2::Ptr{Cdouble}
    v3sigma3::Ptr{Cdouble}
    v4rho4::Ptr{Cdouble}
    v4rho3sigma::Ptr{Cdouble}
    v4rho2sigma2::Ptr{Cdouble}
    v4rhosigma3::Ptr{Cdouble}
    v4sigma4::Ptr{Cdouble}
end

struct xc_mgga_out_params
    zk::Ptr{Cdouble}
    vrho::Ptr{Cdouble}
    vsigma::Ptr{Cdouble}
    vlapl::Ptr{Cdouble}
    vtau::Ptr{Cdouble}
    v2rho2::Ptr{Cdouble}
    v2rhosigma::Ptr{Cdouble}
    v2rholapl::Ptr{Cdouble}
    v2rhotau::Ptr{Cdouble}
    v2sigma2::Ptr{Cdouble}
    v2sigmalapl::Ptr{Cdouble}
    v2sigmatau::Ptr{Cdouble}
    v2lapl2::Ptr{Cdouble}
    v2lapltau::Ptr{Cdouble}
    v2tau2::Ptr{Cdouble}
    v3rho3::Ptr{Cdouble}
    v3rho2sigma::Ptr{Cdouble}
    v3rho2lapl::Ptr{Cdouble}
    v3rho2tau::Ptr{Cdouble}
    v3rhosigma2::Ptr{Cdouble}
    v3rhosigmalapl::Ptr{Cdouble}
    v3rhosigmatau::Ptr{Cdouble}
    v3rholapl2::Ptr{Cdouble}
    v3rholapltau::Ptr{Cdouble}
    v3rhotau2::Ptr{Cdouble}
    v3sigma3::Ptr{Cdouble}
    v3sigma2lapl::Ptr{Cdouble}
    v3sigma2tau::Ptr{Cdouble}
    v3sigmalapl2::Ptr{Cdouble}
    v3sigmalapltau::Ptr{Cdouble}
    v3sigmatau2::Ptr{Cdouble}
    v3lapl3::Ptr{Cdouble}
    v3lapl2tau::Ptr{Cdouble}
    v3lapltau2::Ptr{Cdouble}
    v3tau3::Ptr{Cdouble}
    v4rho4::Ptr{Cdouble}
    v4rho3sigma::Ptr{Cdouble}
    v4rho3lapl::Ptr{Cdouble}
    v4rho3tau::Ptr{Cdouble}
    v4rho2sigma2::Ptr{Cdouble}
    v4rho2sigmalapl::Ptr{Cdouble}
    v4rho2sigmatau::Ptr{Cdouble}
    v4rho2lapl2::Ptr{Cdouble}
    v4rho2lapltau::Ptr{Cdouble}
    v4rho2tau2::Ptr{Cdouble}
    v4rhosigma3::Ptr{Cdouble}
    v4rhosigma2lapl::Ptr{Cdouble}
    v4rhosigma2tau::Ptr{Cdouble}
    v4rhosigmalapl2::Ptr{Cdouble}
    v4rhosigmalapltau::Ptr{Cdouble}
    v4rhosigmatau2::Ptr{Cdouble}
    v4rholapl3::Ptr{Cdouble}
    v4rholapl2tau::Ptr{Cdouble}
    v4rholapltau2::Ptr{Cdouble}
    v4rhotau3::Ptr{Cdouble}
    v4sigma4::Ptr{Cdouble}
    v4sigma3lapl::Ptr{Cdouble}
    v4sigma3tau::Ptr{Cdouble}
    v4sigma2lapl2::Ptr{Cdouble}
    v4sigma2lapltau::Ptr{Cdouble}
    v4sigma2tau2::Ptr{Cdouble}
    v4sigmalapl3::Ptr{Cdouble}
    v4sigmalapl2tau::Ptr{Cdouble}
    v4sigmalapltau2::Ptr{Cdouble}
    v4sigmatau3::Ptr{Cdouble}
    v4lapl4::Ptr{Cdouble}
    v4lapl3tau::Ptr{Cdouble}
    v4lapl2tau2::Ptr{Cdouble}
    v4lapltau3::Ptr{Cdouble}
    v4tau4::Ptr{Cdouble}
end

# typedef void ( * xc_lda_funcs ) ( const struct xc_func_type * p , size_t np , const double * rho , xc_lda_out_params * out )
const xc_lda_funcs = Ptr{Cvoid}

struct xc_lda_funcs_variants
    unpol::NTuple{5, xc_lda_funcs}
    pol::NTuple{5, xc_lda_funcs}
end

# typedef void ( * xc_gga_funcs ) ( const struct xc_func_type * p , size_t np , const double * rho , const double * sigma , xc_gga_out_params * out )
const xc_gga_funcs = Ptr{Cvoid}

struct xc_gga_funcs_variants
    unpol::NTuple{5, xc_gga_funcs}
    pol::NTuple{5, xc_gga_funcs}
end

# typedef void ( * xc_mgga_funcs ) ( const struct xc_func_type * p , size_t np , const double * rho , const double * sigma , const double * lapl , const double * tau , xc_mgga_out_params * out )
const xc_mgga_funcs = Ptr{Cvoid}

struct xc_mgga_funcs_variants
    unpol::NTuple{5, xc_mgga_funcs}
    pol::NTuple{5, xc_mgga_funcs}
end

struct xc_func_info_type
    number::Cint
    kind::Cint
    name::Ptr{Cchar}
    family::Cint
    refs::NTuple{5, Ptr{func_reference_type}}
    flags::Cint
    dens_threshold::Cdouble
    ext_params::func_params_type
    init::Ptr{Cvoid}
    _end::Ptr{Cvoid}
    lda::Ptr{xc_lda_funcs_variants}
    gga::Ptr{xc_gga_funcs_variants}
    mgga::Ptr{xc_mgga_funcs_variants}
end

struct xc_dimensions
    rho::Cint
    sigma::Cint
    lapl::Cint
    tau::Cint
    zk::Cint
    vrho::Cint
    vsigma::Cint
    vlapl::Cint
    vtau::Cint
    v2rho2::Cint
    v2rhosigma::Cint
    v2rholapl::Cint
    v2rhotau::Cint
    v2sigma2::Cint
    v2sigmalapl::Cint
    v2sigmatau::Cint
    v2lapl2::Cint
    v2lapltau::Cint
    v2tau2::Cint
    v3rho3::Cint
    v3rho2sigma::Cint
    v3rho2lapl::Cint
    v3rho2tau::Cint
    v3rhosigma2::Cint
    v3rhosigmalapl::Cint
    v3rhosigmatau::Cint
    v3rholapl2::Cint
    v3rholapltau::Cint
    v3rhotau2::Cint
    v3sigma3::Cint
    v3sigma2lapl::Cint
    v3sigma2tau::Cint
    v3sigmalapl2::Cint
    v3sigmalapltau::Cint
    v3sigmatau2::Cint
    v3lapl3::Cint
    v3lapl2tau::Cint
    v3lapltau2::Cint
    v3tau3::Cint
    v4rho4::Cint
    v4rho3sigma::Cint
    v4rho3lapl::Cint
    v4rho3tau::Cint
    v4rho2sigma2::Cint
    v4rho2sigmalapl::Cint
    v4rho2sigmatau::Cint
    v4rho2lapl2::Cint
    v4rho2lapltau::Cint
    v4rho2tau2::Cint
    v4rhosigma3::Cint
    v4rhosigma2lapl::Cint
    v4rhosigma2tau::Cint
    v4rhosigmalapl2::Cint
    v4rhosigmalapltau::Cint
    v4rhosigmatau2::Cint
    v4rholapl3::Cint
    v4rholapl2tau::Cint
    v4rholapltau2::Cint
    v4rhotau3::Cint
    v4sigma4::Cint
    v4sigma3lapl::Cint
    v4sigma3tau::Cint
    v4sigma2lapl2::Cint
    v4sigma2lapltau::Cint
    v4sigma2tau2::Cint
    v4sigmalapl3::Cint
    v4sigmalapl2tau::Cint
    v4sigmalapltau2::Cint
    v4sigmatau3::Cint
    v4lapl4::Cint
    v4lapl3tau::Cint
    v4lapl2tau2::Cint
    v4lapltau3::Cint
    v4tau4::Cint
end

struct xc_func_type
    info::Ptr{xc_func_info_type}
    nspin::Cint
    n_func_aux::Cint
    func_aux::Ptr{Ptr{xc_func_type}}
    mix_coef::Ptr{Cdouble}
    cam_omega::Cdouble
    cam_alpha::Cdouble
    cam_beta::Cdouble
    nlc_b::Cdouble
    nlc_C::Cdouble
    dim::xc_dimensions
    ext_params::Ptr{Cdouble}
    params::Ptr{Cvoid}
    dens_threshold::Cdouble
    zeta_threshold::Cdouble
    sigma_threshold::Cdouble
    tau_threshold::Cdouble
end

const XC_VERSION = "7.0.0"

const XC_MAJOR_VERSION = 7

const XC_MINOR_VERSION = 0

const XC_MICRO_VERSION = 0

const XC_UNPOLARIZED = 1

const XC_POLARIZED = 2

const XC_NON_RELATIVISTIC = 0

const XC_RELATIVISTIC = 1

const XC_EXCHANGE = 0

const XC_CORRELATION = 1

const XC_EXCHANGE_CORRELATION = 2

const XC_KINETIC = 3

const XC_FAMILY_UNKNOWN = -1

const XC_FAMILY_LDA = 1

const XC_FAMILY_GGA = 2

const XC_FAMILY_MGGA = 4

const XC_FAMILY_LCA = 8

const XC_FAMILY_OEP = 16

const XC_FAMILY_HYB_GGA = 32

const XC_FAMILY_HYB_MGGA = 64

const XC_FAMILY_HYB_LDA = 128

const XC_FLAGS_HAVE_EXC = 1 << 0

const XC_FLAGS_HAVE_VXC = 1 << 1

const XC_FLAGS_HAVE_FXC = 1 << 2

const XC_FLAGS_HAVE_KXC = 1 << 3

const XC_FLAGS_HAVE_LXC = 1 << 4

const XC_FLAGS_1D = 1 << 5

const XC_FLAGS_2D = 1 << 6

const XC_FLAGS_3D = 1 << 7

const XC_FLAGS_HYB_CAM = 1 << 8

const XC_FLAGS_HYB_CAMY = 1 << 9

const XC_FLAGS_VV10 = 1 << 10

const XC_FLAGS_HYB_LC = 1 << 11

const XC_FLAGS_HYB_LCY = 1 << 12

const XC_FLAGS_STABLE = 1 << 13

const XC_FLAGS_DEVELOPMENT = 1 << 14

const XC_FLAGS_NEEDS_LAPLACIAN = 1 << 15

const XC_FLAGS_NEEDS_TAU = 1 << 16

const XC_FLAGS_ENFORCE_FHC = 1 << 17

const XC_FLAGS_HAVE_ALL = (((XC_FLAGS_HAVE_EXC | XC_FLAGS_HAVE_VXC) | XC_FLAGS_HAVE_FXC) | XC_FLAGS_HAVE_KXC) | XC_FLAGS_HAVE_LXC

const XC_EXT_PARAMS_DEFAULT = -999998888

const XC_MAX_REFERENCES = 5

# Skipping MacroDefinition: XC_COMMA ,

