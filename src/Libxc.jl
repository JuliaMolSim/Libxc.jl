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
export Functional
export evaluate
export evaluate!

end # module
