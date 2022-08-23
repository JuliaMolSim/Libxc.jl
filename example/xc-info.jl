using Libxc
using Printf

#length(ARGS) == 1 || error("Usage: xc-info.jl identifier")

#func = Functional(Symbol(ARGS[1]))
func = Functional(:GGA_XC_B97_D)
for s in (:identifier, :name, :family, :kind)
    @printf "%-10s: %-20s\n" string(s) getproperty(func, s)
end

println()
if is_global_hybrid(func)
    println("This is a global hybrid functional with $(100func.exx_coefficient)% " *
            "exact exchange")
elseif is_range_separated(func)
    print("This is a range-separated hybrid functional with range-separation " *
          "constant $(func.omega) and $(100func.alpha + 100func.beta)% short-range " *
          "and $(100func.alpha) long-range exact exchange")
    if :hyb_lcy in func.flags || :hym_camy in func.flags
        println("using the Yukawa kernel.")
    elseif :hyb_lc in func.flags || :hym_cam in func.flags
        println("using the Coulomb kernel.")
    end
else
    println("This is a pure functional with no exact exchange.")
end

println()
println("References:")
for ref in func.references
    println("  *) $(ref.reference)")
    if !isempty(ref.doi)
        println("     doi: $(ref.doi)")
    end
end

println()
println("Implementation has support for:")
:exc in func.flags && println("  *) energy")
:vxc in func.flags && println("  *) 1st derivative (potential)")
:fxc in func.flags && println("  *) 2nd derivative (kernel)")
:kxc in func.flags && println("  *) 3rd derivative")
:lxc in func.flags && println("  *) 4th derivative")
