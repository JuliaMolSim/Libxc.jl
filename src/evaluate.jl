function evaluate_lda!(func::Functional, ρ::Array{Float64}; kwargs...)
    @assert func.family == family_lda
    n_p = Int(length(ρ) / func.n_spin)

    sizes = Dict(:E => n_p, :Vρ => 2n_p, :V2ρ2 => 3n_p, :V3ρ3 => 4n_p)
    if func.n_spin == 1
        for key in keys(sizes)
            sizes[key] = n_p
        end
    end

    dargs = Dict(kwargs)
    for key in keys(dargs)
        if !haskey(sizes, key)
            throw(ArgumentError("Unknown keyword argument: $(string(key))"))
        end
        if length(dargs[key]) != sizes[key]
            throw(DimensionMismatch("Length of keyword argument $(string(key)) == " *
                                    "$(length(dargs[key])) does not agree with expected " *
                                    "value $(sizes[key])"))
        end
    end

    ccall((:xc_lda, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                    Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
          func.pointer, n_p, ρ, get(dargs, :E, C_NULL),
          get(dargs, :Vρ, C_NULL), get(dargs, :V2ρ2, C_NULL), get(dargs, :V3ρ3, C_NULL)
    )
end


function evaluate_gga!(func::Functional, ρ::Array{Float64}, σ::Array{Float64}; kwargs...)
    @assert func.family == family_gga
    n_p = Int(length(ρ) / func.n_spin)

    n_σ = 3n_p
    sizes = Dict(:E => n_p, :Vρ => 2n_p, :Vσ => 3n_p,
                 :V2ρ2 => 3n_p, :V2ρσ => 6n_p, :V2σ2 => 6n_p,
                 :V3ρ3 => 4n_p, :V3ρ2σ => 9n_p, :V3ρσ2 => 12n_p, :V3σ3 => 10n_p)
    if func.n_spin == 1
        n_σ = n_p
        for key in keys(sizes)
            sizes[key] = n_p
        end
    end

    dargs = Dict(kwargs)
    for key in keys(dargs)
        if !haskey(sizes, key)
            throw(ArgumentError("Unknown keyword argument: $(string(key))"))
        end
        if length(dargs[key]) != sizes[key]
            throw(DimensionMismatch("Length of keyword argument $(string(key)) == " *
                                    "$(length(dargs[key])) does not agree with expected " *
                                    "value $(sizes[key])"))
        end
    end

    ccall((:xc_gga, libxc), Cvoid, (Ptr{XCFuncType}, Cint, Ptr{Float64}, Ptr{Float64},
                                    Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
                                    Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
                                    Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
                                    Ptr{Float64}),
          func.pointer, n_p, ρ, σ,
          get(dargs, :E, C_NULL),    get(dargs, :Vρ, C_NULL),    get(dargs, :Vσ, C_NULL),
          get(dargs, :V2ρ2, C_NULL), get(dargs, :V2ρσ, C_NULL),  get(dargs, :V2σ2, C_NULL),
          get(dargs, :V3ρ3, C_NULL), get(dargs, :V3ρ2σ, C_NULL), get(dargs, :V3ρσ2, C_NULL),
          get(dargs, :V3σ3, C_NULL)
    )
end
