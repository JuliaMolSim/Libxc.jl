using Test
using Libxc

# Wrap in an outer testset to get a full report if one test fails
@testset "Libxc.jl" begin
    if "gpu" in ARGS
        include("gpu.jl")
    else
        include("properties.jl")
        include("cpu.jl")
    end
end  # outer wrapper
