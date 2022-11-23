using Clang.Generators
using Libxc_jll

cd(@__DIR__)
include_dir = normpath(Libxc_jll.artifact_dir, "include")
options     = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
push!(args, "-I$include_dir")

headers = [joinpath(include_dir, header)
           for header in ("xc.h", )]

ctx = create_context(headers, args, options)
build!(ctx);

targetdir = joinpath(@__DIR__, "..", "src", "gen")
for file in ("api.jl", "common.jl")
    mv(file, joinpath(targetdir, file), force=true)
end
