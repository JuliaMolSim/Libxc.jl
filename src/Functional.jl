"""
Struct for a Libxc functional and some basic information
"""
mutable struct Functional
    identifier::Symbol
    n_spin::Int
    name::String
    kind::Symbol
    family::Symbol
    flags::Vector{Symbol}
    references::Vector  # Related article references as list of named tuples

    # Spin dimensions libxc expects for various quantities
    # Note: Only the symbols actually meaningful for this functional
    # contain valid information
    spin_dimensions

    # Pointer holding the Libxc representation of this functional
    pointer_::Ptr{xc_func_type}
end


"""
    Functional(identifier::Symbol; n_spin::Integer = 1)

Construct a Functional from a libxc `identifier` and the number
of spins `n_spin` to consider. `
"""
function Functional(identifier::Symbol; n_spin::Integer = 1)
    n_spin in (1, 2) || error("n_spin needs to be 1 or 2")

    number = xc_functional_get_number(string(identifier))
    number == -1 && error("Functional $identifier is not known.")

    function pointer_cleanup(ptr::Ptr{xc_func_type})
        if ptr != C_NULL
            xc_func_end(ptr)
            xc_func_free(ptr)
        end
    end

    pointer = xc_func_alloc()
    ret = xc_func_init(pointer, number, n_spin)
    ret != 0 && error("Something went wrong initialising the functional")

    try
        funcinfo = xc_func_get_info(pointer)
        kind     = KINDMAP[xc_func_info_get_kind(funcinfo)]
        family   = FAMILIYMAP[xc_func_info_get_family(funcinfo)]
        flags    = extract_flags(xc_func_info_get_flags(funcinfo))
        name     = unsafe_string(xc_func_info_get_name(funcinfo))
        references = extract_references(funcinfo)
        dimensions = unsafe_load(pointer).dim

        # Make functional and attach finalizer for cleaning up the pointer
        func = Functional(identifier, n_spin, name, kind, family, flags,
                          references, dimensions, pointer)
        finalizer(cls -> pointer_cleanup(cls.pointer_), func)
        return func
    catch
        pointer_cleanup(pointer)
        rethrow()
    end
end

"""Is the functional an LDA or hybrid LDA functional"""
is_lda(func::Functional)    = func.family in (:lda, :hyb_lda)

"""Is the functional a GGA or hybrid GGA functional"""
is_gga(func::Functional)    = func.family in (:gga, :hyb_gga)

"""Is the functional a meta-GGA or hybrid meta-GGA functional"""
is_mgga(func::Functional)   = func.family in (:mgga, :hyb_mgga)

"""Is the functional a hybrid functional (global or range-separated)"""
is_hybrid(func::Functional) = func.family in (:hyb_gga, :hyb_lda, :hyb_mgga)

"""Is the functional a VV10-type non-local density functional"""
is_vv10(func::Functional)   = :vv10 in func.flags

"""Is the functional a range-separated hybrid functional"""
function is_range_separated(func::Functional)
    is_hybrid(func) || return false
    any(flag in (:hyb_cam, :hyb_camy, :hyb_lc, :hyb_lcy) for flag in func.flags)
end

"""Is the functional a global hybrid functional"""
is_global_hybrid(func::Functional) = is_hybrid(func) && !is_range_separated(func)


# Supported properties:
#     - density_threshold  Density cutoff
#     - exx_coefficient    Exact exchange for global hybrid functionals
#     - cam_omega          Range separation constant for range-separated hybrids
#     - cam_alpha          Long-range exact exchange for range-separated hybrids
#     - cam_beta           Additional exchange for short-range for range-separated hybrids
#                          (i.e. short-range exact exchange is cam_alpha + cam_beta)
#     - nlc_b              Parameter for the VV10-type functionals
#     - nlc_C              Parameter for the VV10-type functionals

import Base.getproperty, Base.setproperty!, Base.propertynames
function Base.propertynames(func::Functional, private=false)
    ret = [:density_threshold, :exx_coefficient,
           :cam_alpha, :cam_beta, :cam_omega, :nlc_b, :nlc_C]
    append!(ret, fieldnames(Functional))
end

function Base.getproperty(func::Functional, s::Symbol)
    if s == :density_threshold
        return Float64(unsafe_load(func.pointer_).dens_threshold)
    elseif s == :exx_coefficient
        return is_global_hybrid(func) ? Float64(xc_hyb_exx_coef(func.pointer_)) : nothing
    elseif s in (:cam_alpha, :cam_beta, :cam_omega)
        is_range_separated(func) || return nothing
        data = (cam_omega = Ref(0.0), cam_alpha = Ref(0.0), cam_beta  = Ref(0.0))
        xc_hyb_cam_coef(func.pointer_, data.cam_omega, data.cam_alpha, data.cam_beta)
        return getproperty(data, s)[]
    elseif s in (:nlc_b, :nlc_C)
        is_vv10(func) || return nothing
        data = (nlc_b=Ref(0.0), nlc_C=Ref(0.0))
        xc_nlc_coef(func.pointer_, data.nlc_b, data.nlc_C)
        return getproperty(data, s)[]
    else
        getfield(func, s)
    end
end

function Base.setproperty!(func::Functional, s::Symbol, v)
    if s == :density_threshold
        xc_func_set_dens_threshold(func.pointer_, Cdouble(v))
    else
        error("Setting property $s is not allowed or implemented.")
    end
end


# Provide maps which translate between the conventions
# used in Libxc.jl and libxc

const KINDMAP = Dict(
    XC_EXCHANGE             => :exchange,
    XC_CORRELATION          => :correlation,
    XC_EXCHANGE_CORRELATION => :exchange_correlation,
    XC_KINETIC              => :kinetic,
)

const FAMILIYMAP = Dict(
    XC_FAMILY_UNKNOWN   => :unknown,
    XC_FAMILY_LDA       => :lda,
    XC_FAMILY_GGA       => :gga,
    XC_FAMILY_MGGA      => :mgga,
    XC_FAMILY_LCA       => :lca,
    XC_FAMILY_OEP       => :oep,
    XC_FAMILY_HYB_GGA   => :hyb_gga,
    XC_FAMILY_HYB_MGGA  => :hyb_mgga,
    XC_FAMILY_HYB_LDA   => :hyb_lda,
)

const FLAGMAP = Dict(
    XC_FLAGS_HAVE_EXC        => :exc,
    XC_FLAGS_HAVE_VXC        => :vxc,
    XC_FLAGS_HAVE_FXC        => :fxc,
    XC_FLAGS_HAVE_KXC        => :kxc,
    XC_FLAGS_HAVE_LXC        => :lxc,
    XC_FLAGS_1D              => :dim1,
    XC_FLAGS_2D              => :dim2,
    XC_FLAGS_3D              => :dim3,
    XC_FLAGS_HYB_CAM         => :hyb_cam,
    XC_FLAGS_HYB_CAMY        => :hym_camy,
    XC_FLAGS_VV10            => :vv10,
    XC_FLAGS_HYB_LC          => :hyb_lc,
    XC_FLAGS_HYB_LCY         => :hyb_lcy,
    XC_FLAGS_STABLE          => :stable,
    XC_FLAGS_DEVELOPMENT     => :development,
    XC_FLAGS_NEEDS_LAPLACIAN => :needs_laplacian,
)

function extract_flags(flags)
    ret = Symbol[]
    for (flag, sym) in pairs(FLAGMAP)
        flag & flags > 0 && push!(ret, sym)
    end
    ret
end

function extract_references(info::Ptr{xc_func_info_type})
    # Range of set references
    refrange = filter(iref -> xc_func_info_get_references(info, iref) != C_NULL,
                      0:XC_MAX_REFERENCES - 1)

    map(refrange) do iref
        ref_ptr = xc_func_info_get_references(info, iref)
        (reference=unsafe_string(xc_func_reference_get_ref(ref_ptr)),
         doi=unsafe_string(xc_func_reference_get_doi(ref_ptr)),
         bibtex=unsafe_string(xc_func_reference_get_bibtex(ref_ptr)))
    end
end
