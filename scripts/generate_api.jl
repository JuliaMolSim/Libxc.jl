using Clang

if !isfile(joinpath(@__DIR__, "../Project.toml"))
    error("Run from scripts directory.")
end

# Download libxc sources
LIBXC_VERSION = "5.1.0"
if !isfile(joinpath(@__DIR__, "libxc/src/xc.h"))
    download("https://gitlab.com/libxc/libxc/-/archive/$LIBXC_VERSION/" *
             "libxc-$LIBXC_VERSION.tar.gz", "libxc.tar.gz")
    run(`tar xf libxc.tar.gz`)
    libxc_dir = only(d for d in readdir(".") if startswith(d, "libxc-"))
    run(`ln -sf $libxc_dir libxc`)
    rm("libxc.tar.gz")
    @assert isfile(joinpath(@__DIR__, "libxc/src/xc.h"))
end

# Generate API wrapper
LIBXC_INCLUDE = normpath(joinpath(@__DIR__, "libxc/src"))
LIBXC_HEADERS = [joinpath(LIBXC_INCLUDE, header) for header in ["xc.h"]]
OUTPUTDIR = joinpath(@__DIR__, "../src/gen")

wc = init(;headers=LIBXC_HEADERS,
          output_file=joinpath(OUTPUTDIR, "libxc.jl"),
          common_file=joinpath(OUTPUTDIR, "libxc_common.jl"),
          header_library = x -> "libxc",
          clang_includes = vcat(LIBXC_INCLUDE, CLANG_INCLUDE),
          header_wrapped = (root, current) -> root == current,
          clang_diagnostics = false,
          )

run(wc)

# Cleanup unused files
for file in ["ctypes.jl", "LibTemplate.jl"]
    rm(joinpath(OUTPUTDIR, file), force=true)
end
