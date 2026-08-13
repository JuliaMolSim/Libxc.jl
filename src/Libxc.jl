module Libxc
using Libxc_jll: libxc
import Libxc_GPU_jll
using Preferences: @load_preference, @set_preferences!, @delete_preferences!

include("gen/common.jl")
include("gen/api.jl")
include("Functional.jl")
include("evaluate.jl")

const libxc_version = VersionNumber(XC_VERSION)
const libxc_doi = unsafe_string(Libxc.xc_reference_doi())

"""
Return the path to the CUDA version of libxc.

A local path configured via [`set_cuda_libxc_path!`](@ref) takes precedence.
If no local path is configured, fall back to the library provided by
[`Libxc_GPU_jll`](@ref) when available.
"""
cuda_libxc_path() = @load_preference("libxc_cuda_path",
                                      Libxc_GPU_jll.is_available() ? Libxc_GPU_jll.libxc : nothing)

"""Is the CUDA version of libxc available on this platform"""
has_cuda() = !isnothing(cuda_libxc_path())

"""
    set_cuda_libxc_path!(path::Union{AbstractString,Nothing})

Configure a local CUDA version of libxc to use instead of the one provided
by [`Libxc_GPU_jll`](@ref). The `path` must point to a shared library
compatible with the CUDA version in use.

Set `path` to `nothing` to remove a previously configured local path and
fall back to [`Libxc_GPU_jll`](@ref).

The preference is stored in `LocalPreferences.toml` and takes effect after
restarting Julia.
"""
function set_cuda_libxc_path!(path::Union{AbstractString,Nothing})
    if isnothing(path)
        @delete_preferences!("libxc_cuda_path")
    else
        isfile(path) || error("Path $path does not exist.")
        @set_preferences!("libxc_cuda_path" => path)
    end
end

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
export needs_laplacian, needs_tau
export cuda_libxc_path, set_cuda_libxc_path!

end  # module
