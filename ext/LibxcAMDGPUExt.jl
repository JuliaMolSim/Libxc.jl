module LibxcAMDGPUExt
using Libxc: Libxc, xc_func_type, Functional, amdgpu_libxc_path, @define_gpu_methods
using AMDGPU

function __init__()
    if AMDGPU.functional()
        if isnothing(amdgpu_libxc_path)
            @warn("No HIP build of libxc is available for the current platform. " *
                  "You can provide a path to a local libxc build via " *
                  "`Libxc.set_amdgpu_libxc_path!`, or rely on the CPU library.")
        end
    end
end

if !isnothing(amdgpu_libxc_path)
    @define_gpu_methods amdgpu_libxc_path AMDGPU.ROCArray{Float64} Ptr{Cdouble} C_NULL
end

end  # module
