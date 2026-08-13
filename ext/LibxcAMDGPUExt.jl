module LibxcAMDGPUExt
using Libxc: Libxc, xc_func_type, Functional, amdgpu_libxc_path, @define_gpu_methods
using AMDGPU

const libxc_amdgpu = amdgpu_libxc_path()
if !isnothing(libxc_amdgpu)
    @define_gpu_methods libxc_amdgpu AMDGPU.ROCArray{Float64} Ptr{Cdouble} C_NULL
end

end  # module
