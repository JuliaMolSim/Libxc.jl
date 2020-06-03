module Libxc
using Libxc_jll
const libxc = Libxc_jll.libxc

include("gen/libxc_common.jl")
include("gen/libxc.jl")
include("wrapper.jl")

const libxc_version = xc_version()
export available_functionals

export Functional
include("Functional.jl")

# export evaluate_lda!
# export evaluate_gga!
# include("evaluate.jl")

end # module
