"""Return the list of available libxc functionals as strings"""
function available_functionals()
    n_xc = ccall((:xc_number_of_functionals, libxc), Cint, ())
    max_string_length = ccall((:xc_maximum_name_length, libxc), Cint, ())

    funcnames = Vector{String}(undef, n_xc)
    for i in 1:n_xc
        funcnames[i] = "\0"^(max_string_length + 2)
    end
    ccall((:xc_available_functional_names, libxc), Cvoid, (Ptr{Ptr{UInt8}}, ), funcnames)
    [string(split(funcnames[i], "\0")[1]) for i in 1:n_xc]
end

@enum FunctionalKind begin
    functional_exchange             = 0
    functional_correlation          = 1
    functional_exchange_correlation = 2
    functional_kinetic              = 3
end

@enum FunctionalFamily begin
    family_unknown  = -1
    family_lda      = 1
    family_gga      = 2
    family_mggai    = 4
    family_lca      = 8
    family_oep      = 16
    family_hyb_gga  = 32
    family_hyb_mgga = 64
end

mutable struct Functional
    number::Int
    identifier::Symbol
    kind::FunctionalKind
    family::FunctionalFamily
    n_spin::Int

    # Pointer holding the LibXC representation of this functional
    pointer::Ptr{XCFuncType}
end


"""
    Functional(identifier::Symbol; n_spin::Integer = 1)

Construct a Functional from a libxc `identifier` and the number
of spins `n_spin` to consider. `
"""
function Functional(identifier::Symbol; n_spin::Integer = 1)
    if n_spin != 1 && n_spin != 2
        error("n_spin needs to be 1 or 2")
    end

    number = ccall((:xc_functional_get_number, libxc), Cint, (Cstring, ),
                   string(identifier))
    if number == -1
        error("Functional $identifier is not known.")
    end

    function pointer_cleanup(ptr::Ptr{XCFuncType})
        if ptr != C_NULL
            xc_func_end(ptr)
            xc_func_free(ptr)
        end
    end

    pointer = xc_func_alloc()
    ret = xc_func_init(pointer, number, n_spin)
    if ret != 0
        error("Something went wrong initialising the functional")
    end

    try
        funcinfo = xc_func_get_info(pointer)
        kind = xc_func_info_get_kind(funcinfo)
        family = xc_func_info_get_family(funcinfo)
        flags = xc_func_info_get_flags(funcinfo)
        # TODO Extract references ....

        # Make functional and attach finalizer for cleaning up the pointer
        func = Functional(number, identifier, FunctionalKind(kind),
                          FunctionalFamily(family), n_spin, pointer)
        finalizer(cls -> pointer_cleanup(cls.pointer), func)
        return func
    catch
        pointer_cleanup(pointer)
        rethrow()
    end
end
