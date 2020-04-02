module Libxc
using Libxc_jll
const libxc = Libxc_jll.libxc

include("version.jl")
include("xc.jl")
include("functionals_info.jl")

export Functional
include("Functional.jl")

export evaluate_lda!
export evaluate_gga!
include("evaluate.jl")

end # module
