# The required / allowed input and output arguments per functional family
# :input refers to input argument and numbers to the derivative order
const ARGUMENTS = Dict(
    :lda => [[:zk], [:vrho], [:v2rho2], [:v3rho3], [:v4rho4], ],
    :gga => [
        [:zk],
        [:vrho, :vsigma],
        [:v2rho2, :v2rhosigma, :v2sigma2],
        [:v3rho3, :v3rho2sigma, :v3rhosigma2, :v3sigma3],
        [:v4rho4, :v4rho3sigma, :v4rho2sigma2, :v4rhosigma3, :v4sigma4],
    ],
    :mgga => [
        [:zk],
        [:vrho, :vsigma, :vlapl, :vtau],
        [:v2rho2, :v2rhosigma, :v2rholapl, :v2rhotau, :v2sigma2, :v2sigmalapl,
         :v2sigmatau, :v2lapl2, :v2lapltau, :v2tau2],
        [:v3rho3, :v3rho2sigma, :v3rho2lapl, :v3rho2tau, :v3rhosigma2, :v3rhosigmalapl,
         :v3rhosigmatau, :v3rholapl2, :v3rholapltau, :v3rhotau2, :v3sigma3, :v3sigma2lapl,
         :v3sigma2tau, :v3sigmalapl2, :v3sigmalapltau, :v3sigmatau2, :v3lapl3,
         :v3lapl2tau, :v3lapltau2, :v3tau3],
        [:v4rho4, :v4rho3sigma, :v4rho3lapl, :v4rho3tau, :v4rho2sigma2, :v4rho2sigmalapl,
         :v4rho2sigmatau, :v4rho2lapl2, :v4rho2lapltau, :v4rho2tau2, :v4rhosigma3,
         :v4rhosigma2lapl, :v4rhosigma2tau, :v4rhosigmalapl2, :v4rhosigmalapltau,
         :v4rhosigmatau2, :v4rholapl3, :v4rholapl2tau, :v4rholapltau2, :v4rhotau3,
         :v4sigma4, :v4sigma3lapl, :v4sigma3tau, :v4sigma2lapl2, :v4sigma2lapltau,
         :v4sigma2tau2, :v4sigmalapl3, :v4sigmalapl2tau, :v4sigmalapltau2, :v4sigmatau3,
         :v4lapl4, :v4lapl3tau, :v4lapl2tau2, :v4lapltau3, :v4tau4],
     ],
)

# Hybrid or not, the arguments are the same
ARGUMENTS[:hyb_lda] = ARGUMENTS[:lda]
ARGUMENTS[:hyb_gga] = ARGUMENTS[:lda]
ARGUMENTS[:hyb_mgga] = ARGUMENTS[:lda]

const INPUT = Dict(
    :lda => [:rho],
    :gga => [:rho, :sigma],
    :mgga => [:rho, :sigma, :lapl, :tau],
)

# Hybrid or not, the inputs are the same
INPUT[:hyb_lda] = INPUT[:lda]
INPUT[:hyb_gga] = INPUT[:gga]
INPUT[:hyb_mgga] = INPUT[:mgga]

function derivative_flag(family, argument)
    flags = (:exc, :vxc, :fxc, :kxc, :lxc)  # flags for having 0th to 4th derivative
    for (i, arglist) in enumerate(ARGUMENTS[family])
        (argument in arglist) && return (i - 1, flags[i])
    end
    (-1, :unknown)
end

"""
Evaluate a functional obtaining the energy and / or certain derivatives of it.
What is returned depends on `derivatives`, which should be a range of derivative
orders, e.g. `0:1` (the default) for the energy and potential, `0:0` for just the
energy and so on.
The required input arguments depend on the functional type (`rho` for all functionals,
`sigma` for GGA and mGGA, `tau` and `lapl` for mGGA). Obtained data is returned
as a named tuple.
"""
function evaluate(func::Functional; derivatives=0:1, rho::AbstractArray, kwargs...)
    @assert all(0 .≤ derivatives .≤ 4)
    if !all(d in supported_derivatives(func) for d in derivatives)
        throw(ArgumentError("Functional $(func.identifier) does only support derivatives " *
                            "of orders $(supported_derivatives(func)), but you " *
                            "requested $derivatives."))
    end

    # Determine the gridshape (i.e. the shape of the grid points without the spin components)
    if ndims(rho) > 1
        if size(rho, 1) != func.spin_dimensions.rho
            error("First axis for multidimensional rho array should be equal " *
                  "to the number of spin components (== $(func.spin_dimensions.rho))")
        end
        gridshape = size(rho)[2:end]
    else
        if mod(length(rho), func.spin_dimensions.rho) != 0
            error("Length of linear rho array should be divisible by number of spin " *
                  "components in rho (== $(func.spin_dimensions.rho)).")
        end
        gridshape = (Int(length(rho) / func.spin_dimensions.rho), )
    end

    # Output arguments, where memory is already allocated
    outargs_allocated = Dict{Symbol, AbstractArray}()
    outargs = Dict{Symbol, AbstractArray}()
    for symbol in vcat(ARGUMENTS[func.family][1 .+ derivatives]...)
        if symbol in keys(kwargs)
            outargs_allocated[symbol] = kwargs[symbol]
        elseif symbol == :zk  # For zk keep just the grid shape
            outargs[symbol] = similar(rho, gridshape)
        else
            n_spin = getfield(func.spin_dimensions, symbol)
            outargs[symbol] = similar(rho, n_spin, gridshape...)
        end
    end

    evaluate!(func; rho=rho, kwargs..., outargs...)
    (; outargs..., outargs_allocated...)
end


"""
Evaluate a functional and store results in passed arrays. If for a particular
quantity no array is passed, it is not computed. Required input arguments
depend on the functional type (`rho` for all functionals, `sigma` for GGA and mGGA,
`tau` and `lapl` for mGGA).
"""
function evaluate!(func::Functional; rho::AbstractArray, kwargs...)
    mod(length(rho), func.spin_dimensions.rho) != 0 && error(
        "Length of rho array should be divisible by number of spin " *
        "components in rho (== $(func.spin_dimensions.rho))."
    )

    n_p = Int(length(rho) / func.spin_dimensions.rho)
    kwargs = Dict(kwargs)
    for argument in vcat(INPUT[func.family]..., ARGUMENTS[func.family]...)
        argument == :rho && continue
        haskey(kwargs, argument) || continue

        # Check dimensionality
        n_spin = getfield(func.spin_dimensions, argument)
        if length(kwargs[argument]) != n_spin * n_p
            throw(DimensionMismatch("$argument should have n_spin * n_p elements " *
                                    "(n_spin=$n_spin, n_p=$n_p"))
        end

        # Check derivative support in functional
        order, flag = derivative_flag(func.family, argument)
        if !(flag in func.flags) && flag != :unknown
            throw(ArgumentError("Functional $(func.identifier) does not support " *
                                "derivatives of order $order (like $argument)."))
        end

    end
    evaluate!(func, Val(func.family), rho; kwargs...)
end


# Array typedefs specifically to the Array type supported in Libxc
# Allows providing special versions of evaluate! for other types of arrays.
# Dispatch can be done on the rho argument, which is not a kwarg in this function.
const OptArray = Union{Array{Float64}, Ptr{Nothing}}


function evaluate!(func::Functional, ::Union{Val{:lda},Val{:hyb_lda}}, rho::Array{Float64};
                   zk::OptArray=C_NULL,
                   vrho::OptArray=C_NULL, v2rho2::OptArray=C_NULL,
                   v3rho3::OptArray=C_NULL, v4rho4::OptArray=C_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)
    xc_lda(func.pointer_, np, rho, zk, vrho, v2rho2, v3rho3, v4rho4)
end


function evaluate!(func::Functional, ::Union{Val{:gga},Val{:hyb_gga}}, rho::Array{Float64};
                   sigma::Array{Float64}, zk::OptArray=C_NULL,
                   vrho::OptArray=C_NULL, vsigma::OptArray=C_NULL,
                   v2rho2::OptArray=C_NULL, v2rhosigma::OptArray=C_NULL,
                   v2sigma2::OptArray=C_NULL,
                   v3rho3::OptArray=C_NULL, v3rho2sigma::OptArray=C_NULL,
                   v3rhosigma2::OptArray=C_NULL, v3sigma3::OptArray=C_NULL,
                   v4rho4::OptArray=C_NULL, v4rho3sigma::OptArray=C_NULL,
                   v4rho2sigma2::OptArray=C_NULL, v4rhosigma3::OptArray=C_NULL,
                   v4sigma4::OptArray=C_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)
    xc_gga(func.pointer_, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2,
           v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3,
           v4rho4, v4rho3sigma, v4rho2sigma2, v4rhosigma3, v4sigma4)
end


function evaluate!(func::Functional, ::Union{Val{:mgga},Val{:hyb_mgga}}, rho::Array{Float64};
                   sigma::Array{Float64}, tau::Array{Float64}, lapl::OptArray=C_NULL,
                   zk::OptArray=C_NULL,
                   vrho::OptArray=C_NULL,
                   vsigma::OptArray=C_NULL,
                   vlapl::OptArray=C_NULL,
                   vtau::OptArray=C_NULL,
                   v2rho2::OptArray=C_NULL,
                   v2rhosigma::OptArray=C_NULL,
                   v2rholapl::OptArray=C_NULL,
                   v2rhotau::OptArray=C_NULL,
                   v2sigma2::OptArray=C_NULL,
                   v2sigmalapl::OptArray=C_NULL,
                   v2sigmatau::OptArray=C_NULL,
                   v2lapl2::OptArray=C_NULL,
                   v2lapltau::OptArray=C_NULL,
                   v2tau2::OptArray=C_NULL,
                   v3rho3::OptArray=C_NULL,
                   v3rho2sigma::OptArray=C_NULL,
                   v3rho2lapl::OptArray=C_NULL,
                   v3rho2tau::OptArray=C_NULL,
                   v3rhosigma2::OptArray=C_NULL,
                   v3rhosigmalapl::OptArray=C_NULL,
                   v3rhosigmatau::OptArray=C_NULL,
                   v3rholapl2::OptArray=C_NULL,
                   v3rholapltau::OptArray=C_NULL,
                   v3rhotau2::OptArray=C_NULL,
                   v3sigma3::OptArray=C_NULL,
                   v3sigma2lapl::OptArray=C_NULL,
                   v3sigma2tau::OptArray=C_NULL,
                   v3sigmalapl2::OptArray=C_NULL,
                   v3sigmalapltau::OptArray=C_NULL,
                   v3sigmatau2::OptArray=C_NULL,
                   v3lapl3::OptArray=C_NULL,
                   v3lapl2tau::OptArray=C_NULL,
                   v3lapltau2::OptArray=C_NULL,
                   v3tau3::OptArray=C_NULL,
                   v4rho4::OptArray=C_NULL,
                   v4rho3sigma::OptArray=C_NULL,
                   v4rho3lapl::OptArray=C_NULL,
                   v4rho3tau::OptArray=C_NULL,
                   v4rho2sigma2::OptArray=C_NULL,
                   v4rho2sigmalapl::OptArray=C_NULL,
                   v4rho2sigmatau::OptArray=C_NULL,
                   v4rho2lapl2::OptArray=C_NULL,
                   v4rho2lapltau::OptArray=C_NULL,
                   v4rho2tau2::OptArray=C_NULL,
                   v4rhosigma3::OptArray=C_NULL,
                   v4rhosigma2lapl::OptArray=C_NULL,
                   v4rhosigma2tau::OptArray=C_NULL,
                   v4rhosigmalapl2::OptArray=C_NULL,
                   v4rhosigmalapltau::OptArray=C_NULL,
                   v4rhosigmatau2::OptArray=C_NULL,
                   v4rholapl3::OptArray=C_NULL,
                   v4rholapl2tau::OptArray=C_NULL,
                   v4rholapltau2::OptArray=C_NULL,
                   v4rhotau3::OptArray=C_NULL,
                   v4sigma4::OptArray=C_NULL,
                   v4sigma3lapl::OptArray=C_NULL,
                   v4sigma3tau::OptArray=C_NULL,
                   v4sigma2lapl2::OptArray=C_NULL,
                   v4sigma2lapltau::OptArray=C_NULL,
                   v4sigma2tau2::OptArray=C_NULL,
                   v4sigmalapl3::OptArray=C_NULL,
                   v4sigmalapl2tau::OptArray=C_NULL,
                   v4sigmalapltau2::OptArray=C_NULL,
                   v4sigmatau3::OptArray=C_NULL,
                   v4lapl4::OptArray=C_NULL,
                   v4lapl3tau::OptArray=C_NULL,
                   v4lapl2tau2::OptArray=C_NULL,
                   v4lapltau3::OptArray=C_NULL,
                   v4tau4::OptArray=C_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)
    xc_mgga(func.pointer_, np, rho, sigma, lapl, tau, zk, vrho, vsigma, vlapl, vtau,
            v2rho2, v2rhosigma, v2rholapl, v2rhotau, v2sigma2, v2sigmalapl,
            v2sigmatau, v2lapl2, v2lapltau, v2tau2, v3rho3, v3rho2sigma,
            v3rho2lapl, v3rho2tau, v3rhosigma2, v3rhosigmalapl, v3rhosigmatau,
            v3rholapl2, v3rholapltau, v3rhotau2, v3sigma3, v3sigma2lapl,
            v3sigma2tau, v3sigmalapl2, v3sigmalapltau, v3sigmatau2, v3lapl3,
            v3lapl2tau, v3lapltau2, v3tau3, v4rho4, v4rho3sigma, v4rho3lapl,
            v4rho3tau, v4rho2sigma2, v4rho2sigmalapl, v4rho2sigmatau,
            v4rho2lapl2, v4rho2lapltau, v4rho2tau2, v4rhosigma3,
            v4rhosigma2lapl, v4rhosigma2tau, v4rhosigmalapl2,
            v4rhosigmalapltau, v4rhosigmatau2, v4rholapl3, v4rholapl2tau,
            v4rholapltau2, v4rhotau3, v4sigma4, v4sigma3lapl, v4sigma3tau,
            v4sigma2lapl2, v4sigma2lapltau, v4sigma2tau2, v4sigmalapl3,
            v4sigmalapl2tau, v4sigmalapltau2, v4sigmatau3, v4lapl4, v4lapl3tau,
            v4lapl2tau2, v4lapltau3, v4tau4)
end
