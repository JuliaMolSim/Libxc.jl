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
        dimensions = unsafe_load(pointer).dim

        # Make functional and attach finalizer for cleaning up the pointer
        func = Functional(identifier, n_spin, name, kind, family, flags,
                          dimensions, pointer)
        finalizer(cls -> pointer_cleanup(cls.pointer_), func)
        return func
    catch
        pointer_cleanup(pointer)
        rethrow()
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
