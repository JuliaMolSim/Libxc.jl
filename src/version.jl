function xc_version()
    varray = zeros(Cint, 3)
    ccall((:xc_version, libxc), Cvoid, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          pointer(varray, 1), pointer(varray, 2), pointer(varray, 3))
    VersionNumber(varray[1], varray[2], varray[3])
end

function xc_version_string()
    s = ccall( (:xc_version_string, libxc), Ptr{UInt8}, () )
    return unsafe_string(s)
end
