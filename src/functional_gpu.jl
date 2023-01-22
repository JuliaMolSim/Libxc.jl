import Libxc_GPU_jll
const libxc_gpu  = Libxc_GPU_jll.libxc

function allocate_gpufunctional(identifier::Symbol, n_spin::Integer)
    n_spin in (1, 2) || error("n_spin needs to be 1 or 2")

    number  = @ccall libxc_gpu.xc_functional_get_number(string(identifier)::Cstring)::Cint
    number == -1 && error("Functional $identifier is not known.")

    pointer = @ccall libxc_gpu.xc_func_alloc()::Ptr{xc_func_type}
    ret = @ccall libxc_gpu.xc_func_init(pointer::Ptr{xc_func_type}, number::Cint,
                                        n_spin::Cint)::Cint
    ret != 0 && error("Something went wrong initialising the functional")

    pointer
end
allocate_gpufunctional(func::Functional) = allocate_gpufunctional(func.identifier, func.n_spin)

function deallocate_gpufunctional(pointer::Ptr{xc_func_type})
    if pointer != C_NULL
        @ccall libxc_gpu.xc_func_end(pointer::Ptr{xc_func_type})::Cvoid
        @ccall libxc_gpu.xc_func_free(pointer::Ptr{xc_func_type})::Cvoid
    end
end
