# Automatically generated using Clang.jl


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
    params::Ptr{Cvoid}
    dens_threshold::Cdouble
    zeta_threshold::Cdouble
    sigma_threshold::Cdouble
    tau_threshold::Cdouble
end

const XC_VERSION = "6.0.0"

const XC_MAJOR_VERSION = 6

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

const XC_FLAGS_HAVE_ALL = (((XC_FLAGS_HAVE_EXC | XC_FLAGS_HAVE_VXC) | XC_FLAGS_HAVE_FXC) | XC_FLAGS_HAVE_KXC) | XC_FLAGS_HAVE_LXC

const XC_EXT_PARAMS_DEFAULT = -999998888

const XC_TAU_EXPLICIT = 0

const XC_TAU_EXPANSION = 1

const XC_MAX_REFERENCES = 5

# Skipping MacroDefinition: XC_COMMA ,

const XC_LDA_X = 1

const XC_LDA_C_WIGNER = 2

const XC_LDA_C_RPA = 3

const XC_LDA_C_HL = 4

const XC_LDA_C_GL = 5

const XC_LDA_C_XALPHA = 6

const XC_LDA_C_VWN = 7

const XC_LDA_C_VWN_RPA = 8

const XC_LDA_C_PZ = 9

const XC_LDA_C_PZ_MOD = 10

const XC_LDA_C_OB_PZ = 11

const XC_LDA_C_PW = 12

const XC_LDA_C_PW_MOD = 13

const XC_LDA_C_OB_PW = 14

const XC_LDA_C_2D_AMGB = 15

const XC_LDA_C_2D_PRM = 16

const XC_LDA_C_VBH = 17

const XC_LDA_C_1D_CSC = 18

const XC_LDA_X_2D = 19

const XC_LDA_XC_TETER93 = 20

const XC_LDA_X_1D_SOFT = 21

const XC_LDA_C_ML1 = 22

const XC_LDA_C_ML2 = 23

const XC_LDA_C_GOMBAS = 24

const XC_LDA_C_PW_RPA = 25

const XC_LDA_C_1D_LOOS = 26

const XC_LDA_C_RC04 = 27

const XC_LDA_C_VWN_1 = 28

const XC_LDA_C_VWN_2 = 29

const XC_LDA_C_VWN_3 = 30

const XC_LDA_C_VWN_4 = 31

const XC_GGA_X_GAM = 32

const XC_GGA_C_GAM = 33

const XC_GGA_X_HCTH_A = 34

const XC_GGA_X_EV93 = 35

const XC_HYB_MGGA_X_DLDF = 36

const XC_MGGA_C_DLDF = 37

const XC_GGA_X_BCGP = 38

const XC_GGA_C_ACGGA = 39

const XC_GGA_X_LAMBDA_OC2_N = 40

const XC_GGA_X_B86_R = 41

const XC_MGGA_XC_ZLP = 42

const XC_LDA_XC_ZLP = 43

const XC_GGA_X_LAMBDA_CH_N = 44

const XC_GGA_X_LAMBDA_LO_N = 45

const XC_GGA_X_HJS_B88_V2 = 46

const XC_GGA_C_Q2D = 47

const XC_GGA_X_Q2D = 48

const XC_GGA_X_PBE_MOL = 49

const XC_LDA_K_TF = 50

const XC_LDA_K_LP = 51

const XC_GGA_K_TFVW = 52

const XC_GGA_K_REVAPBEINT = 53

const XC_GGA_K_APBEINT = 54

const XC_GGA_K_REVAPBE = 55

const XC_GGA_X_AK13 = 56

const XC_GGA_K_MEYER = 57

const XC_GGA_X_LV_RPW86 = 58

const XC_GGA_X_PBE_TCA = 59

const XC_GGA_X_PBEINT = 60

const XC_GGA_C_ZPBEINT = 61

const XC_GGA_C_PBEINT = 62

const XC_GGA_C_ZPBESOL = 63

const XC_MGGA_XC_OTPSS_D = 64

const XC_GGA_XC_OPBE_D = 65

const XC_GGA_XC_OPWLYP_D = 66

const XC_GGA_XC_OBLYP_D = 67

const XC_GGA_X_VMT84_GE = 68

const XC_GGA_X_VMT84_PBE = 69

const XC_GGA_X_VMT_GE = 70

const XC_GGA_X_VMT_PBE = 71

const XC_MGGA_C_CS = 72

const XC_MGGA_C_MN12_SX = 73

const XC_MGGA_C_MN12_L = 74

const XC_MGGA_C_M11_L = 75

const XC_MGGA_C_M11 = 76

const XC_MGGA_C_M08_SO = 77

const XC_MGGA_C_M08_HX = 78

const XC_GGA_C_N12_SX = 79

const XC_GGA_C_N12 = 80

const XC_HYB_GGA_X_N12_SX = 81

const XC_GGA_X_N12 = 82

const XC_GGA_C_REGTPSS = 83

const XC_GGA_C_OP_XALPHA = 84

const XC_GGA_C_OP_G96 = 85

const XC_GGA_C_OP_PBE = 86

const XC_GGA_C_OP_B88 = 87

const XC_GGA_C_FT97 = 88

const XC_GGA_C_SPBE = 89

const XC_GGA_X_SSB_SW = 90

const XC_GGA_X_SSB = 91

const XC_GGA_X_SSB_D = 92

const XC_GGA_XC_HCTH_407P = 93

const XC_GGA_XC_HCTH_P76 = 94

const XC_GGA_XC_HCTH_P14 = 95

const XC_GGA_XC_B97_GGA1 = 96

const XC_GGA_C_HCTH_A = 97

const XC_GGA_X_BPCCAC = 98

const XC_GGA_C_REVTCA = 99

const XC_GGA_C_TCA = 100

const XC_GGA_X_PBE = 101

const XC_GGA_X_PBE_R = 102

const XC_GGA_X_B86 = 103

const XC_GGA_X_HERMAN = 104

const XC_GGA_X_B86_MGC = 105

const XC_GGA_X_B88 = 106

const XC_GGA_X_G96 = 107

const XC_GGA_X_PW86 = 108

const XC_GGA_X_PW91 = 109

const XC_GGA_X_OPTX = 110

const XC_GGA_X_DK87_R1 = 111

const XC_GGA_X_DK87_R2 = 112

const XC_GGA_X_LG93 = 113

const XC_GGA_X_FT97_A = 114

const XC_GGA_X_FT97_B = 115

const XC_GGA_X_PBE_SOL = 116

const XC_GGA_X_RPBE = 117

const XC_GGA_X_WC = 118

const XC_GGA_X_MPW91 = 119

const XC_GGA_X_AM05 = 120

const XC_GGA_X_PBEA = 121

const XC_GGA_X_MPBE = 122

const XC_GGA_X_XPBE = 123

const XC_GGA_X_2D_B86_MGC = 124

const XC_GGA_X_BAYESIAN = 125

const XC_GGA_X_PBE_JSJR = 126

const XC_GGA_X_2D_B88 = 127

const XC_GGA_X_2D_B86 = 128

const XC_GGA_X_2D_PBE = 129

const XC_GGA_C_PBE = 130

const XC_GGA_C_LYP = 131

const XC_GGA_C_P86 = 132

const XC_GGA_C_PBE_SOL = 133

const XC_GGA_C_PW91 = 134

const XC_GGA_C_AM05 = 135

const XC_GGA_C_XPBE = 136

const XC_GGA_C_LM = 137

const XC_GGA_C_PBE_JRGX = 138

const XC_GGA_X_OPTB88_VDW = 139

const XC_GGA_X_PBEK1_VDW = 140

const XC_GGA_X_OPTPBE_VDW = 141

const XC_GGA_X_RGE2 = 142

const XC_GGA_C_RGE2 = 143

const XC_GGA_X_RPW86 = 144

const XC_GGA_X_KT1 = 145

const XC_GGA_XC_KT2 = 146

const XC_GGA_C_WL = 147

const XC_GGA_C_WI = 148

const XC_GGA_X_MB88 = 149

const XC_GGA_X_SOGGA = 150

const XC_GGA_X_SOGGA11 = 151

const XC_GGA_C_SOGGA11 = 152

const XC_GGA_C_WI0 = 153

const XC_GGA_XC_TH1 = 154

const XC_GGA_XC_TH2 = 155

const XC_GGA_XC_TH3 = 156

const XC_GGA_XC_TH4 = 157

const XC_GGA_X_C09X = 158

const XC_GGA_C_SOGGA11_X = 159

const XC_GGA_X_LB = 160

const XC_GGA_XC_HCTH_93 = 161

const XC_GGA_XC_HCTH_120 = 162

const XC_GGA_XC_HCTH_147 = 163

const XC_GGA_XC_HCTH_407 = 164

const XC_GGA_XC_EDF1 = 165

const XC_GGA_XC_XLYP = 166

const XC_GGA_XC_KT1 = 167

const XC_GGA_X_LSPBE = 168

const XC_GGA_X_LSRPBE = 169

const XC_GGA_XC_B97_D = 170

const XC_GGA_X_OPTB86B_VDW = 171

const XC_MGGA_C_REVM11 = 172

const XC_GGA_XC_PBE1W = 173

const XC_GGA_XC_MPWLYP1W = 174

const XC_GGA_XC_PBELYP1W = 175

const XC_GGA_C_ACGGAP = 176

const XC_HYB_LDA_XC_LDA0 = 177

const XC_HYB_LDA_XC_CAM_LDA0 = 178

const XC_GGA_X_B88_6311G = 179

const XC_GGA_X_NCAP = 180

const XC_GGA_XC_NCAP = 181

const XC_GGA_X_LBM = 182

const XC_GGA_X_OL2 = 183

const XC_GGA_X_APBE = 184

const XC_GGA_K_APBE = 185

const XC_GGA_C_APBE = 186

const XC_GGA_K_TW1 = 187

const XC_GGA_K_TW2 = 188

const XC_GGA_K_TW3 = 189

const XC_GGA_K_TW4 = 190

const XC_GGA_X_HTBS = 191

const XC_GGA_X_AIRY = 192

const XC_GGA_X_LAG = 193

const XC_GGA_XC_MOHLYP = 194

const XC_GGA_XC_MOHLYP2 = 195

const XC_GGA_XC_TH_FL = 196

const XC_GGA_XC_TH_FC = 197

const XC_GGA_XC_TH_FCFO = 198

const XC_GGA_XC_TH_FCO = 199

const XC_GGA_C_OPTC = 200

const XC_MGGA_X_LTA = 201

const XC_MGGA_X_TPSS = 202

const XC_MGGA_X_M06_L = 203

const XC_MGGA_X_GVT4 = 204

const XC_MGGA_X_TAU_HCTH = 205

const XC_MGGA_X_BR89 = 206

const XC_MGGA_X_BJ06 = 207

const XC_MGGA_X_TB09 = 208

const XC_MGGA_X_RPP09 = 209

const XC_MGGA_X_2D_PRHG07 = 210

const XC_MGGA_X_2D_PRHG07_PRP10 = 211

const XC_MGGA_X_REVTPSS = 212

const XC_MGGA_X_PKZB = 213

const XC_MGGA_X_BR89_1 = 214

const XC_GGA_X_ECMV92 = 215

const XC_GGA_C_PBE_VWN = 216

const XC_GGA_C_P86_FT = 217

const XC_GGA_K_RATIONAL_P = 218

const XC_GGA_K_PG1 = 219

const XC_MGGA_K_PGSL025 = 220

const XC_MGGA_X_MS0 = 221

const XC_MGGA_X_MS1 = 222

const XC_MGGA_X_MS2 = 223

const XC_HYB_MGGA_X_MS2H = 224

const XC_MGGA_X_TH = 225

const XC_MGGA_X_M11_L = 226

const XC_MGGA_X_MN12_L = 227

const XC_MGGA_X_MS2_REV = 228

const XC_MGGA_XC_CC06 = 229

const XC_MGGA_X_MK00 = 230

const XC_MGGA_C_TPSS = 231

const XC_MGGA_C_VSXC = 232

const XC_MGGA_C_M06_L = 233

const XC_MGGA_C_M06_HF = 234

const XC_MGGA_C_M06 = 235

const XC_MGGA_C_M06_2X = 236

const XC_MGGA_C_M05 = 237

const XC_MGGA_C_M05_2X = 238

const XC_MGGA_C_PKZB = 239

const XC_MGGA_C_BC95 = 240

const XC_MGGA_C_REVTPSS = 241

const XC_MGGA_XC_TPSSLYP1W = 242

const XC_MGGA_X_MK00B = 243

const XC_MGGA_X_BLOC = 244

const XC_MGGA_X_MODTPSS = 245

const XC_GGA_C_PBELOC = 246

const XC_MGGA_C_TPSSLOC = 247

const XC_HYB_MGGA_X_MN12_SX = 248

const XC_MGGA_X_MBEEF = 249

const XC_MGGA_X_MBEEFVDW = 250

const XC_MGGA_C_TM = 251

const XC_GGA_C_P86VWN = 252

const XC_GGA_C_P86VWN_FT = 253

const XC_MGGA_XC_B97M_V = 254

const XC_GGA_XC_VV10 = 255

const XC_MGGA_X_JK = 256

const XC_MGGA_X_MVS = 257

const XC_GGA_C_PBEFE = 258

const XC_LDA_XC_KSDT = 259

const XC_MGGA_X_MN15_L = 260

const XC_MGGA_C_MN15_L = 261

const XC_GGA_C_OP_PW91 = 262

const XC_MGGA_X_SCAN = 263

const XC_HYB_MGGA_X_SCAN0 = 264

const XC_GGA_X_PBEFE = 265

const XC_HYB_GGA_XC_B97_1P = 266

const XC_MGGA_C_SCAN = 267

const XC_HYB_MGGA_X_MN15 = 268

const XC_MGGA_C_MN15 = 269

const XC_GGA_X_CAP = 270

const XC_GGA_X_EB88 = 271

const XC_GGA_C_PBE_MOL = 272

const XC_HYB_GGA_XC_PBE_MOL0 = 273

const XC_HYB_GGA_XC_PBE_SOL0 = 274

const XC_HYB_GGA_XC_PBEB0 = 275

const XC_HYB_GGA_XC_PBE_MOLB0 = 276

const XC_GGA_K_ABSP3 = 277

const XC_GGA_K_ABSP4 = 278

const XC_HYB_MGGA_X_BMK = 279

const XC_GGA_C_BMK = 280

const XC_GGA_C_TAU_HCTH = 281

const XC_HYB_MGGA_X_TAU_HCTH = 282

const XC_GGA_C_HYB_TAU_HCTH = 283

const XC_MGGA_X_B00 = 284

const XC_GGA_X_BEEFVDW = 285

const XC_GGA_XC_BEEFVDW = 286

const XC_LDA_C_CHACHIYO = 287

const XC_MGGA_XC_HLE17 = 288

const XC_LDA_C_LP96 = 289

const XC_HYB_GGA_XC_PBE50 = 290

const XC_GGA_X_PBETRANS = 291

const XC_MGGA_C_SCAN_RVV10 = 292

const XC_MGGA_X_REVM06_L = 293

const XC_MGGA_C_REVM06_L = 294

const XC_HYB_MGGA_X_M08_HX = 295

const XC_HYB_MGGA_X_M08_SO = 296

const XC_HYB_MGGA_X_M11 = 297

const XC_GGA_X_CHACHIYO = 298

const XC_MGGA_X_RTPSS = 299

const XC_MGGA_X_MS2B = 300

const XC_MGGA_X_MS2BS = 301

const XC_MGGA_X_MVSB = 302

const XC_MGGA_X_MVSBS = 303

const XC_HYB_MGGA_X_REVM11 = 304

const XC_HYB_MGGA_X_REVM06 = 305

const XC_MGGA_C_REVM06 = 306

const XC_LDA_C_CHACHIYO_MOD = 307

const XC_LDA_C_KARASIEV_MOD = 308

const XC_GGA_C_CHACHIYO = 309

const XC_HYB_MGGA_X_M06_SX = 310

const XC_MGGA_C_M06_SX = 311

const XC_GGA_X_REVSSB_D = 312

const XC_GGA_C_CCDF = 313

const XC_HYB_GGA_XC_HFLYP = 314

const XC_HYB_GGA_XC_B3P86_NWCHEM = 315

const XC_GGA_X_PW91_MOD = 316

const XC_LDA_C_W20 = 317

const XC_LDA_XC_CORRKSDT = 318

const XC_MGGA_X_FT98 = 319

const XC_GGA_X_PBE_MOD = 320

const XC_GGA_X_PBE_GAUSSIAN = 321

const XC_GGA_C_PBE_GAUSSIAN = 322

const XC_MGGA_C_TPSS_GAUSSIAN = 323

const XC_GGA_X_NCAPR = 324

const XC_GGA_XC_B97_3C = 327

const XC_MGGA_C_CC = 387

const XC_MGGA_C_CCALDA = 388

const XC_HYB_MGGA_XC_BR3P86 = 389

const XC_HYB_GGA_XC_CASE21 = 390

const XC_MGGA_C_RREGTM = 391

const XC_HYB_GGA_XC_PBE_2X = 392

const XC_HYB_GGA_XC_PBE38 = 393

const XC_HYB_GGA_XC_B3LYP3 = 394

const XC_HYB_GGA_XC_CAM_O3LYP = 395

const XC_HYB_MGGA_XC_TPSS0 = 396

const XC_MGGA_C_B94 = 397

const XC_HYB_MGGA_XC_B94_HYB = 398

const XC_HYB_GGA_XC_WB97X_D3 = 399

const XC_HYB_GGA_XC_LC_BLYP = 400

const XC_HYB_GGA_XC_B3PW91 = 401

const XC_HYB_GGA_XC_B3LYP = 402

const XC_HYB_GGA_XC_B3P86 = 403

const XC_HYB_GGA_XC_O3LYP = 404

const XC_HYB_GGA_XC_MPW1K = 405

const XC_HYB_GGA_XC_PBEH = 406

const XC_HYB_GGA_XC_B97 = 407

const XC_HYB_GGA_XC_B97_1 = 408

const XC_HYB_GGA_XC_APF = 409

const XC_HYB_GGA_XC_B97_2 = 410

const XC_HYB_GGA_XC_X3LYP = 411

const XC_HYB_GGA_XC_B1WC = 412

const XC_HYB_GGA_XC_B97_K = 413

const XC_HYB_GGA_XC_B97_3 = 414

const XC_HYB_GGA_XC_MPW3PW = 415

const XC_HYB_GGA_XC_B1LYP = 416

const XC_HYB_GGA_XC_B1PW91 = 417

const XC_HYB_GGA_XC_MPW1PW = 418

const XC_HYB_GGA_XC_MPW3LYP = 419

const XC_HYB_GGA_XC_SB98_1A = 420

const XC_HYB_GGA_XC_SB98_1B = 421

const XC_HYB_GGA_XC_SB98_1C = 422

const XC_HYB_GGA_XC_SB98_2A = 423

const XC_HYB_GGA_XC_SB98_2B = 424

const XC_HYB_GGA_XC_SB98_2C = 425

const XC_HYB_GGA_X_SOGGA11_X = 426

const XC_HYB_GGA_XC_HSE03 = 427

const XC_HYB_GGA_XC_HSE06 = 428

const XC_HYB_GGA_XC_HJS_PBE = 429

const XC_HYB_GGA_XC_HJS_PBE_SOL = 430

const XC_HYB_GGA_XC_HJS_B88 = 431

const XC_HYB_GGA_XC_HJS_B97X = 432

const XC_HYB_GGA_XC_CAM_B3LYP = 433

const XC_HYB_GGA_XC_TUNED_CAM_B3LYP = 434

const XC_HYB_GGA_XC_BHANDH = 435

const XC_HYB_GGA_XC_BHANDHLYP = 436

const XC_HYB_GGA_XC_MB3LYP_RC04 = 437

const XC_HYB_MGGA_X_M05 = 438

const XC_HYB_MGGA_X_M05_2X = 439

const XC_HYB_MGGA_XC_B88B95 = 440

const XC_HYB_MGGA_XC_B86B95 = 441

const XC_HYB_MGGA_XC_PW86B95 = 442

const XC_HYB_MGGA_XC_BB1K = 443

const XC_HYB_MGGA_X_M06_HF = 444

const XC_HYB_MGGA_XC_MPW1B95 = 445

const XC_HYB_MGGA_XC_MPWB1K = 446

const XC_HYB_MGGA_XC_X1B95 = 447

const XC_HYB_MGGA_XC_XB1K = 448

const XC_HYB_MGGA_X_M06 = 449

const XC_HYB_MGGA_X_M06_2X = 450

const XC_HYB_MGGA_XC_PW6B95 = 451

const XC_HYB_MGGA_XC_PWB6K = 452

const XC_HYB_GGA_XC_MPWLYP1M = 453

const XC_HYB_GGA_XC_REVB3LYP = 454

const XC_HYB_GGA_XC_CAMY_BLYP = 455

const XC_HYB_GGA_XC_PBE0_13 = 456

const XC_HYB_MGGA_XC_TPSSH = 457

const XC_HYB_MGGA_XC_REVTPSSH = 458

const XC_HYB_GGA_XC_B3LYPS = 459

const XC_HYB_GGA_XC_QTP17 = 460

const XC_HYB_GGA_XC_B3LYP_MCM1 = 461

const XC_HYB_GGA_XC_B3LYP_MCM2 = 462

const XC_HYB_GGA_XC_WB97 = 463

const XC_HYB_GGA_XC_WB97X = 464

const XC_HYB_GGA_XC_LRC_WPBEH = 465

const XC_HYB_GGA_XC_WB97X_V = 466

const XC_HYB_GGA_XC_LCY_PBE = 467

const XC_HYB_GGA_XC_LCY_BLYP = 468

const XC_HYB_GGA_XC_LC_VV10 = 469

const XC_HYB_GGA_XC_CAMY_B3LYP = 470

const XC_HYB_GGA_XC_WB97X_D = 471

const XC_HYB_GGA_XC_HPBEINT = 472

const XC_HYB_GGA_XC_LRC_WPBE = 473

const XC_HYB_MGGA_X_MVSH = 474

const XC_HYB_GGA_XC_B3LYP5 = 475

const XC_HYB_GGA_XC_EDF2 = 476

const XC_HYB_GGA_XC_CAP0 = 477

const XC_HYB_GGA_XC_LC_WPBE = 478

const XC_HYB_GGA_XC_HSE12 = 479

const XC_HYB_GGA_XC_HSE12S = 480

const XC_HYB_GGA_XC_HSE_SOL = 481

const XC_HYB_GGA_XC_CAM_QTP_01 = 482

const XC_HYB_GGA_XC_MPW1LYP = 483

const XC_HYB_GGA_XC_MPW1PBE = 484

const XC_HYB_GGA_XC_KMLYP = 485

const XC_HYB_GGA_XC_LC_WPBE_WHS = 486

const XC_HYB_GGA_XC_LC_WPBEH_WHS = 487

const XC_HYB_GGA_XC_LC_WPBE08_WHS = 488

const XC_HYB_GGA_XC_LC_WPBESOL_WHS = 489

const XC_HYB_GGA_XC_CAM_QTP_00 = 490

const XC_HYB_GGA_XC_CAM_QTP_02 = 491

const XC_HYB_GGA_XC_LC_QTP = 492

const XC_MGGA_X_RSCAN = 493

const XC_MGGA_C_RSCAN = 494

const XC_GGA_X_S12G = 495

const XC_HYB_GGA_X_S12H = 496

const XC_MGGA_X_R2SCAN = 497

const XC_MGGA_C_R2SCAN = 498

const XC_HYB_GGA_XC_BLYP35 = 499

const XC_GGA_K_VW = 500

const XC_GGA_K_GE2 = 501

const XC_GGA_K_GOLDEN = 502

const XC_GGA_K_YT65 = 503

const XC_GGA_K_BALTIN = 504

const XC_GGA_K_LIEB = 505

const XC_GGA_K_ABSP1 = 506

const XC_GGA_K_ABSP2 = 507

const XC_GGA_K_GR = 508

const XC_GGA_K_LUDENA = 509

const XC_GGA_K_GP85 = 510

const XC_GGA_K_PEARSON = 511

const XC_GGA_K_OL1 = 512

const XC_GGA_K_OL2 = 513

const XC_GGA_K_FR_B88 = 514

const XC_GGA_K_FR_PW86 = 515

const XC_GGA_K_DK = 516

const XC_GGA_K_PERDEW = 517

const XC_GGA_K_VSK = 518

const XC_GGA_K_VJKS = 519

const XC_GGA_K_ERNZERHOF = 520

const XC_GGA_K_LC94 = 521

const XC_GGA_K_LLP = 522

const XC_GGA_K_THAKKAR = 523

const XC_GGA_X_WPBEH = 524

const XC_GGA_X_HJS_PBE = 525

const XC_GGA_X_HJS_PBE_SOL = 526

const XC_GGA_X_HJS_B88 = 527

const XC_GGA_X_HJS_B97X = 528

const XC_GGA_X_ITYH = 529

const XC_GGA_X_SFAT = 530

const XC_HYB_MGGA_XC_WB97M_V = 531

const XC_LDA_X_REL = 532

const XC_GGA_X_SG4 = 533

const XC_GGA_C_SG4 = 534

const XC_GGA_X_GG99 = 535

const XC_LDA_XC_1D_EHWLRG_1 = 536

const XC_LDA_XC_1D_EHWLRG_2 = 537

const XC_LDA_XC_1D_EHWLRG_3 = 538

const XC_GGA_X_PBEPOW = 539

const XC_MGGA_X_TM = 540

const XC_MGGA_X_VT84 = 541

const XC_MGGA_X_SA_TPSS = 542

const XC_MGGA_K_PC07 = 543

const XC_GGA_X_KGG99 = 544

const XC_GGA_XC_HLE16 = 545

const XC_LDA_X_ERF = 546

const XC_LDA_XC_LP_A = 547

const XC_LDA_XC_LP_B = 548

const XC_LDA_X_RAE = 549

const XC_LDA_K_ZLP = 550

const XC_LDA_C_MCWEENY = 551

const XC_LDA_C_BR78 = 552

const XC_GGA_C_SCAN_E0 = 553

const XC_LDA_C_PK09 = 554

const XC_GGA_C_GAPC = 555

const XC_GGA_C_GAPLOC = 556

const XC_GGA_C_ZVPBEINT = 557

const XC_GGA_C_ZVPBESOL = 558

const XC_GGA_C_TM_LYP = 559

const XC_GGA_C_TM_PBE = 560

const XC_GGA_C_W94 = 561

const XC_MGGA_C_KCIS = 562

const XC_HYB_MGGA_XC_B0KCIS = 563

const XC_MGGA_XC_LP90 = 564

const XC_GGA_C_CS1 = 565

const XC_HYB_MGGA_XC_MPW1KCIS = 566

const XC_HYB_MGGA_XC_MPWKCIS1K = 567

const XC_HYB_MGGA_XC_PBE1KCIS = 568

const XC_HYB_MGGA_XC_TPSS1KCIS = 569

const XC_GGA_X_B88M = 570

const XC_MGGA_C_B88 = 571

const XC_HYB_GGA_XC_B5050LYP = 572

const XC_LDA_C_OW_LYP = 573

const XC_LDA_C_OW = 574

const XC_MGGA_X_GX = 575

const XC_MGGA_X_PBE_GX = 576

const XC_LDA_XC_GDSMFB = 577

const XC_LDA_C_GK72 = 578

const XC_LDA_C_KARASIEV = 579

const XC_LDA_K_LP96 = 580

const XC_MGGA_X_REVSCAN = 581

const XC_MGGA_C_REVSCAN = 582

const XC_HYB_MGGA_X_REVSCAN0 = 583

const XC_MGGA_C_SCAN_VV10 = 584

const XC_MGGA_C_REVSCAN_VV10 = 585

const XC_MGGA_X_BR89_EXPLICIT = 586

const XC_GGA_XC_KT3 = 587

const XC_HYB_LDA_XC_BN05 = 588

const XC_HYB_GGA_XC_LB07 = 589

const XC_LDA_C_PMGB06 = 590

const XC_GGA_K_GDS08 = 591

const XC_GGA_K_GHDS10 = 592

const XC_GGA_K_GHDS10R = 593

const XC_GGA_K_TKVLN = 594

const XC_GGA_K_PBE3 = 595

const XC_GGA_K_PBE4 = 596

const XC_GGA_K_EXP4 = 597

const XC_HYB_MGGA_XC_B98 = 598

const XC_LDA_XC_TIH = 599

const XC_LDA_X_1D_EXPONENTIAL = 600

const XC_GGA_X_SFAT_PBE = 601

const XC_MGGA_X_BR89_EXPLICIT_1 = 602

const XC_MGGA_X_REGTPSS = 603

const XC_GGA_X_FD_LB94 = 604

const XC_GGA_X_FD_REVLB94 = 605

const XC_GGA_C_ZVPBELOC = 606

const XC_HYB_GGA_XC_APBE0 = 607

const XC_HYB_GGA_XC_HAPBE = 608

const XC_MGGA_X_2D_JS17 = 609

const XC_HYB_GGA_XC_RCAM_B3LYP = 610

const XC_HYB_GGA_XC_WC04 = 611

const XC_HYB_GGA_XC_WP04 = 612

const XC_GGA_K_LKT = 613

const XC_HYB_GGA_XC_CAMH_B3LYP = 614

const XC_HYB_GGA_XC_WHPBE0 = 615

const XC_GGA_K_PBE2 = 616

const XC_MGGA_K_L04 = 617

const XC_MGGA_K_L06 = 618

const XC_GGA_K_VT84F = 619

const XC_GGA_K_LGAP = 620

const XC_MGGA_K_RDA = 621

const XC_GGA_X_ITYH_OPTX = 622

const XC_GGA_X_ITYH_PBE = 623

const XC_GGA_C_LYPR = 624

const XC_HYB_GGA_XC_LC_BLYP_EA = 625

const XC_MGGA_X_REGTM = 626

const XC_MGGA_K_GEA2 = 627

const XC_MGGA_K_GEA4 = 628

const XC_MGGA_K_CSK1 = 629

const XC_MGGA_K_CSK4 = 630

const XC_MGGA_K_CSK_LOC1 = 631

const XC_MGGA_K_CSK_LOC4 = 632

const XC_GGA_K_LGAP_GE = 633

const XC_MGGA_K_PC07_OPT = 634

const XC_GGA_K_TFVW_OPT = 635

const XC_HYB_GGA_XC_LC_BOP = 636

const XC_HYB_GGA_XC_LC_PBEOP = 637

const XC_MGGA_C_KCISK = 638

const XC_HYB_GGA_XC_LC_BLYPR = 639

const XC_HYB_GGA_XC_MCAM_B3LYP = 640

const XC_LDA_X_YUKAWA = 641

const XC_MGGA_C_R2SCAN01 = 642

const XC_MGGA_C_RMGGAC = 643

const XC_MGGA_X_MCML = 644

const XC_MGGA_X_R2SCAN01 = 645

const XC_HYB_GGA_X_CAM_S12G = 646

const XC_HYB_GGA_X_CAM_S12H = 647

const XC_MGGA_X_RPPSCAN = 648

const XC_MGGA_C_RPPSCAN = 649

const XC_MGGA_X_R4SCAN = 650

const XC_MGGA_X_VCML = 651

const XC_MGGA_XC_VCML_RVV10 = 652

const XC_HYB_GGA_XC_CAM_PBEH = 681

const XC_HYB_GGA_XC_CAMY_PBEH = 682

const XC_LDA_C_UPW92 = 683

const XC_LDA_C_RPW92 = 684

const XC_MGGA_X_TLDA = 685

const XC_MGGA_X_EDMGGA = 686

const XC_MGGA_X_GDME_NV = 687

const XC_MGGA_X_RLDA = 688

const XC_MGGA_X_GDME_0 = 689

const XC_MGGA_X_GDME_KOS = 690

const XC_MGGA_X_GDME_VT = 691

const XC_LDA_X_SLOC = 692

const XC_MGGA_X_REVTM = 693

const XC_MGGA_C_REVTM = 694

const XC_HYB_MGGA_XC_EDMGGAH = 695

const XC_MGGA_X_MBRXC_BG = 696

const XC_MGGA_X_MBRXH_BG = 697

const XC_MGGA_X_HLTA = 698

const XC_MGGA_C_HLTAPW = 699

const XC_MGGA_X_SCANL = 700

const XC_MGGA_X_REVSCANL = 701

const XC_MGGA_C_SCANL = 702

const XC_MGGA_C_SCANL_RVV10 = 703

const XC_MGGA_C_SCANL_VV10 = 704

const XC_HYB_MGGA_X_JS18 = 705

const XC_HYB_MGGA_X_PJS18 = 706

const XC_MGGA_X_TASK = 707

const XC_MGGA_X_MGGAC = 711

const XC_GGA_C_MGGAC = 712

const XC_MGGA_X_MBR = 716

const XC_MGGA_X_R2SCANL = 718

const XC_MGGA_C_R2SCANL = 719

const XC_HYB_MGGA_XC_LC_TMLYP = 720

const XC_MGGA_X_MTASK = 724

const XC_GGA_X_Q1D = 734

const XC_LDA_X_1D = 21

const XC_GGA_X_BGCP = 38

const XC_GGA_C_BGCP = 39

const XC_GGA_C_BCGP = 39

const XC_GGA_C_VPBE = 83

const XC_GGA_XC_LB = 160

const XC_MGGA_C_CC06 = 229

const XC_GGA_K_ABSR1 = 506

const XC_GGA_K_ABSR2 = 507

const XC_LDA_C_LP_A = 547

const XC_LDA_C_LP_B = 548

const XC_MGGA_C_LP90 = 564

const XC_LDA_C_vBH = 17

const XC_HYB_GGA_XC_B97_1p = 266

const XC_HYB_GGA_XC_mPW1K = 405

const XC_HYB_GGA_XC_mPW1PW = 418

const XC_HYB_GGA_XC_SB98_1a = 420

const XC_HYB_GGA_XC_SB98_1b = 421

const XC_HYB_GGA_XC_SB98_1c = 422

const XC_HYB_GGA_XC_SB98_2a = 423

const XC_HYB_GGA_XC_SB98_2b = 424

const XC_HYB_GGA_XC_SB98_2c = 425

const XC_HYB_GGA_XC_B3LYPs = 459

const XC_GGA_X_PBEpow = 539

const XC_GGA_XC_B97 = 167

const XC_GGA_XC_B97_1 = 168

const XC_GGA_XC_B97_2 = 169

const XC_GGA_XC_B97_K = 171

const XC_GGA_XC_B97_3 = 172

const XC_GGA_XC_SB98_1a = 176

const XC_GGA_XC_SB98_1b = 177

const XC_GGA_XC_SB98_1c = 178

const XC_GGA_XC_SB98_2a = 179

const XC_GGA_XC_SB98_2b = 180

const XC_GGA_XC_SB98_2c = 181

const XC_MGGA_X_M05 = 214

const XC_MGGA_X_M05_2X = 215

const XC_MGGA_X_M06_HF = 216

const XC_MGGA_X_M06 = 217

const XC_MGGA_X_M06_2X = 218

const XC_MGGA_X_M08_HX = 219

const XC_MGGA_X_M08_SO = 220

const XC_MGGA_X_M11 = 225

const XC_MGGA_X_MN12_SX = 228

const XC_GGA_XC_WB97 = 251

const XC_GGA_XC_WB97X = 252

const XC_GGA_XC_WB97X_V = 253

const XC_GGA_XC_WB97X_D = 256

const XC_HYB_MGGA_XC_M08_HX = 460

const XC_HYB_MGGA_XC_M08_SO = 461

const XC_HYB_MGGA_XC_M11 = 462

