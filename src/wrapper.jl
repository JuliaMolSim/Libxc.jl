# Some convenience wrappers 

"""Get the version of the libxc library as a version string"""
function xc_version()
    varray = zeros(Cint, 3)
    xc_version(pointer(varray, 1), pointer(varray, 2), pointer(varray, 3))
    VersionNumber(varray[1], varray[2], varray[3])
end

"""Return the list of available libxc functionals as strings"""
function available_functionals()
    n_xc = xc_number_of_functionals()
    max_string_length = xc_maximum_name_length()

    funcnames = Vector{String}(undef, n_xc)
    for i in 1:n_xc
        funcnames[i] = ' '^(max_string_length + 2)
    end
    xc_available_functional_names(funcnames)

    [Symbol(first(split(funcnames[i], "\0"))) for i in 1:n_xc]
end
