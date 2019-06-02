module Libxc
using Libdl

# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("Libxc not installed properly, run Pkg.build(\"Libxc\"), restart Julia and try again")
end
include(depsjl_path)

# Module initialization function
function __init__()
    # Always check your dependencies from `deps.jl`
    check_deps()
end

export XCFuncType

include("version.jl")
include("xc.jl")
include("functionals_info.jl")


end # module
