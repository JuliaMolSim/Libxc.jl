using Libdl
using Printf

const root_path = joinpath(@__DIR__, ".")
# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, ".", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("Libxc not installed properly, run Pkg.build(\"Libxc\"), restart Julia and try again")
end
include(depsjl_path)

# Module initialization function
function __init__()
    # Always check your dependencies from `deps.jl`
    check_deps()
end

d = Dict{String, String}()
open(joinpath(root_path, "src", "functionals.jl"), "w") do f
    @show f
    for i in 1:1000
        out = ""
        try
            out = readchomp(`$xcinfo $i`)
        catch
            continue
        end
        ss = split(out, r"\n|\t")

        # Dict_keys are (name: family: kink: func_id: comment:)
        for s in ss[1:5]
            kv = split(s, ":")
            k, v = strip.(kv)
            d[k] = v
        end

        #
        out_str = @sprintf "const  %-26s = %6s # %s\n" uppercase(d["name"]) d["func_id"] d["comment"]
        @show
        write(f, out_str)
    end
end
