using Test
using Libxc

@test isa(Libxc.xc_version(), Tuple{Int64, Int64, Int64})
@test isa(Libxc.xc_version_string(), String)

refer = Libxc.FuncReferType(pointer("ref"), pointer("doi"), pointer("bibtex"))
p = Ref{Libxc.FuncReferType}(refer)
@test unsafe_string(Libxc.xc_func_reference_get_ref(p)) == "ref"
@test unsafe_string(Libxc.xc_func_reference_get_doi(p)) == "doi"
@test unsafe_string(Libxc.xc_func_reference_get_bibtex(p)) == "bibtex"

reff = Libxc.xc_func_alloc()
Libxc.xc_func_init(reff, 1, 1)
info_ref = Libxc.xc_func_get_info(reff)
@test Libxc.xc_func_info_get_number(info_ref) == 1
@test Libxc.xc_func_info_get_kind(info_ref) == 0
@test Libxc.xc_func_info_get_name(info_ref) == "Slater exchange"
@test Libxc.xc_func_info_get_family(info_ref) == 1
@test Libxc.xc_func_info_get_flags(info_ref) == 143
Libxc.xc_func_end(reff)
Libxc.xc_func_free(reff)

@test Libxc.LDA_X == 1
