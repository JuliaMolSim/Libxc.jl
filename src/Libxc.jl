module Libxc
using Libxc_jll
const libxc = Libxc_jll.libxc

include("gen/libxc_common.jl")
include("gen/libxc.jl")
include("Functional.jl")
include("evaluate.jl")

const libxc_version = begin
    varray = zeros(Cint, 3)
    xc_version(pointer(varray, 1), pointer(varray, 2), pointer(varray, 3))
    VersionNumber(varray[1], varray[2], varray[3])
end
const libxc_doi = unsafe_string(Libxc.xc_reference_doi())

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
export Functional, evaluate, evaluate!
export is_lda, is_gga, is_mgga, is_hybrid, is_vv10, is_range_separated, is_global_hybrid

end # module
