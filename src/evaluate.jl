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
const LibxcArray = Array{Float64}
const LibxcOptArray = Union{LibxcArray, Ptr{Nothing}}


function evaluate!(func::Functional, ::Union{Val{:lda},Val{:hyb_lda}}, rho::LibxcArray;
                   zk::LibxcOptArray=C_NULL,
                   vrho::LibxcOptArray=C_NULL, v2rho2::LibxcOptArray=C_NULL,
                   v3rho3::LibxcOptArray=C_NULL, v4rho4::LibxcOptArray=C_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)
    xc_lda(func.pointer_, np, rho, zk, vrho, v2rho2, v3rho3, v4rho4)
end


function evaluate!(func::Functional, ::Union{Val{:gga},Val{:hyb_gga}}, rho::LibxcArray;
                   sigma::LibxcArray, zk::LibxcOptArray=C_NULL,
                   vrho::LibxcOptArray=C_NULL, vsigma::LibxcOptArray=C_NULL,
                   v2rho2::LibxcOptArray=C_NULL, v2rhosigma::LibxcOptArray=C_NULL,
                   v2sigma2::LibxcOptArray=C_NULL,
                   v3rho3::LibxcOptArray=C_NULL, v3rho2sigma::LibxcOptArray=C_NULL,
                   v3rhosigma2::LibxcOptArray=C_NULL, v3sigma3::LibxcOptArray=C_NULL,
                   v4rho4::LibxcOptArray=C_NULL, v4rho3sigma::LibxcOptArray=C_NULL,
                   v4rho2sigma2::LibxcOptArray=C_NULL, v4rhosigma3::LibxcOptArray=C_NULL,
                   v4sigma4::LibxcOptArray=C_NULL)
    np = Int(length(rho) / func.spin_dimensions.rho)
    xc_gga(func.pointer_, np, rho, sigma, zk, vrho, vsigma, v2rho2, v2rhosigma, v2sigma2,
           v3rho3, v3rho2sigma, v3rhosigma2, v3sigma3,
           v4rho4, v4rho3sigma, v4rho2sigma2, v4rhosigma3, v4sigma4)
end


function evaluate!(func::Functional, ::Union{Val{:mgga},Val{:hyb_mgga}}, rho::LibxcArray;
                   sigma::LibxcArray, lapl::LibxcOptArray=C_NULL, tau::LibxcArray,
                   zk::LibxcOptArray=C_NULL,
                   vrho::LibxcOptArray=C_NULL,
                   vsigma::LibxcOptArray=C_NULL,
                   vlapl::LibxcOptArray=C_NULL,
                   vtau::LibxcOptArray=C_NULL,
                   v2rho2::LibxcOptArray=C_NULL,
                   v2rhosigma::LibxcOptArray=C_NULL,
                   v2rholapl::LibxcOptArray=C_NULL,
                   v2rhotau::LibxcOptArray=C_NULL,
                   v2sigma2::LibxcOptArray=C_NULL,
                   v2sigmalapl::LibxcOptArray=C_NULL,
                   v2sigmatau::LibxcOptArray=C_NULL,
                   v2lapl2::LibxcOptArray=C_NULL,
                   v2lapltau::LibxcOptArray=C_NULL,
                   v2tau2::LibxcOptArray=C_NULL,
                   v3rho3::LibxcOptArray=C_NULL,
                   v3rho2sigma::LibxcOptArray=C_NULL,
                   v3rho2lapl::LibxcOptArray=C_NULL,
                   v3rho2tau::LibxcOptArray=C_NULL,
                   v3rhosigma2::LibxcOptArray=C_NULL,
                   v3rhosigmalapl::LibxcOptArray=C_NULL,
                   v3rhosigmatau::LibxcOptArray=C_NULL,
                   v3rholapl2::LibxcOptArray=C_NULL,
                   v3rholapltau::LibxcOptArray=C_NULL,
                   v3rhotau2::LibxcOptArray=C_NULL,
                   v3sigma3::LibxcOptArray=C_NULL,
                   v3sigma2lapl::LibxcOptArray=C_NULL,
                   v3sigma2tau::LibxcOptArray=C_NULL,
                   v3sigmalapl2::LibxcOptArray=C_NULL,
                   v3sigmalapltau::LibxcOptArray=C_NULL,
                   v3sigmatau2::LibxcOptArray=C_NULL,
                   v3lapl3::LibxcOptArray=C_NULL,
                   v3lapl2tau::LibxcOptArray=C_NULL,
                   v3lapltau2::LibxcOptArray=C_NULL,
                   v3tau3::LibxcOptArray=C_NULL,
                   v4rho4::LibxcOptArray=C_NULL,
                   v4rho3sigma::LibxcOptArray=C_NULL,
                   v4rho3lapl::LibxcOptArray=C_NULL,
                   v4rho3tau::LibxcOptArray=C_NULL,
                   v4rho2sigma2::LibxcOptArray=C_NULL,
                   v4rho2sigmalapl::LibxcOptArray=C_NULL,
                   v4rho2sigmatau::LibxcOptArray=C_NULL,
                   v4rho2lapl2::LibxcOptArray=C_NULL,
                   v4rho2lapltau::LibxcOptArray=C_NULL,
                   v4rho2tau2::LibxcOptArray=C_NULL,
                   v4rhosigma3::LibxcOptArray=C_NULL,
                   v4rhosigma2lapl::LibxcOptArray=C_NULL,
                   v4rhosigma2tau::LibxcOptArray=C_NULL,
                   v4rhosigmalapl2::LibxcOptArray=C_NULL,
                   v4rhosigmalapltau::LibxcOptArray=C_NULL,
                   v4rhosigmatau2::LibxcOptArray=C_NULL,
                   v4rholapl3::LibxcOptArray=C_NULL,
                   v4rholapl2tau::LibxcOptArray=C_NULL,
                   v4rholapltau2::LibxcOptArray=C_NULL,
                   v4rhotau3::LibxcOptArray=C_NULL,
                   v4sigma4::LibxcOptArray=C_NULL,
                   v4sigma3lapl::LibxcOptArray=C_NULL,
                   v4sigma3tau::LibxcOptArray=C_NULL,
                   v4sigma2lapl2::LibxcOptArray=C_NULL,
                   v4sigma2lapltau::LibxcOptArray=C_NULL,
                   v4sigma2tau2::LibxcOptArray=C_NULL,
                   v4sigmalapl3::LibxcOptArray=C_NULL,
                   v4sigmalapl2tau::LibxcOptArray=C_NULL,
                   v4sigmalapltau2::LibxcOptArray=C_NULL,
                   v4sigmatau3::LibxcOptArray=C_NULL,
                   v4lapl4::LibxcOptArray=C_NULL,
                   v4lapl3tau::LibxcOptArray=C_NULL,
                   v4lapl2tau2::LibxcOptArray=C_NULL,
                   v4lapltau3::LibxcOptArray=C_NULL,
                   v4tau4::LibxcOptArray=C_NULL)
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
