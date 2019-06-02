function xc_version()
    a = Ref{Cint}(0)
    b = Ref{Cint}(0)
    c = Ref{Cint}(0)
    ccall( (:xc_version, libxc), Cvoid, (Ref{Cint}, Ref{Cint}, Ref{Cint}), a, b, c)
    return Base.convert(Int64, a[]),
           Base.convert(Int64, b[]),
           Base.convert(Int64, c[])
end

function xc_version_string()
    s = ccall( (:xc_version_string, libxc), Ptr{UInt8}, () )
    return unsafe_string(s)
end
