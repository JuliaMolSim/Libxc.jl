module Libxc
using Libxc_jll: libxc
import Libxc_GPU_jll
using Requires  # Only needed in Julia < 1.9

include("gen/common.jl")
include("gen/api.jl")
include("Functional.jl")
include("evaluate.jl")

const libxc_version = VersionNumber(XC_VERSION)
const libxc_doi = unsafe_string(Libxc.xc_reference_doi())

"""Is the CUDA version of libxc available on this platform"""
has_cuda() = Libxc_GPU_jll.is_available()

"""Return the list of available libxc functionals as strings"""
function available_functionals()
    n_xc = xc_number_of_functionals()
    max_string_length = xc_maximum_name_length()

    funcnames = Vector{String}(undef, n_xc)
    for i in 1:n_xc
        funcnames[i] = ' '^(max_string_length + 2)
    end
    xc_available_functional_names(funcnames)

    [Symbol(first(split(funcnames[i], "\0"))) for i in 1:n_xc]
end

export available_functionals
export Functional, evaluate, evaluate!, supported_derivatives
export is_lda, is_gga, is_mgga, is_hybrid, is_vv10, is_range_separated, is_global_hybrid
export needs_laplacian

# Requires-based dependency management for Julia < 1.9
if !isdefined(Base, :get_extension)
    function __init__()
        @require CUDA="052768ef-5323-5732-b1bb-66c8b64840ba" begin
            include("../ext/LibxcCudaExt.jl")
        end
    end
end

end  # module
