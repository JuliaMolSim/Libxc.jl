module Libxc
using Libxc_jll
const libxc = Libxc_jll.libxc

include("gen/libxc_common.jl")
include("gen/libxc.jl")
include("wrapper.jl")
include("Functional.jl")
include("evaluate.jl")

const libxc_version = xc_version()
export available_functionals
export Functional, evaluate, evaluate!
export is_lda, is_gga, is_mgga, is_hybrid, is_vv10, is_range_separated, is_global_hybrid

end # module
