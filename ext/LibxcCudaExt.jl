module LibxcCudaExt
import Libxc_GPU_jll
using Libxc: Libxc, xc_func_type, Functional, cuda_libxc_path, @define_gpu_methods
using CUDA

function __init__()
    if CUDA.functional()
        if isnothing(cuda_libxc_path())
            @warn("No CUDA build of libxc is available for the current platform. " *
                  "If your CUDA installation is from a JLL artifact, note that " *
                  "CUDA > v13.3 is not yet supported. Please use a lower version " *
                  """(e.g. `CUDA.set_runtime_version!(v"12.8")`). """ *
                  "Otherwise, you can provide a path to a local libxc build via " *
                  "`Libxc.set_cuda_libxc_path!`.")
        end
    end
end

const libxc_gpu = cuda_libxc_path()
if !isnothing(libxc_gpu)
    @define_gpu_methods libxc_gpu CUDA.CuArray{Float64} CUDA.CuPtr{Cdouble} CUDA.CU_NULL
end

end  # module
