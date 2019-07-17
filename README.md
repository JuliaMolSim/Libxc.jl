# Libxc.jl
[![Build Status](https://travis-ci.org/unkcpz/Libxc.jl.svg?branch=master)](https://travis-ci.org/unkcpz/Libxc.jl)

julia wrapper of library [Libxc](https://tddft.org/programs/libxc/) (exchange-correlation functionals for density-functional theory. )

Binary built by using [BinaryBuilder](https://github.com/JuliaPackaging/BinaryBuilder.jl) and provided by [BinaryProvider](https://github.com/JuliaPackaging/BinaryProvider.jl).

Now it is registered in [JuliaRegisties](https://github.com/JuliaRegistries/General), thus can be installed by running:

```sh
(v1.1) pkg> add Libxc
```

When wrapping new libxc version, first run `update_functionals_info.jl` to update functionals' info


## Examples
`Libxc.jl` offers both a low-level interface, semantically very close to `libxc`
as well as a more `julia`n high-level interface.

Usage from the low-level interface:
```julia
using Libxc

rho = [0.1, 0.2, 0.3, 0.4, 0.5]
sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
result = zeros(Float64, 5)

# LDA exchange
ptr = Libxc.xc_func_alloc()
Libxc.xc_func_init(ptr, Libxc.LDA_X, 1)
Libxc.xc_lda_exc!(ptr, 5, rho, result)

@show result
# [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194]
Libxc.xc_func_end(ptr)
Libxc.xc_func_free(ptr)

# GGA exchange
ptr = Libxc.xc_func_alloc()
Libxc.xc_func_init(ptr, Libxc.GGA_X_PBE, 1)
Libxc.xc_gga_exc!(ptr, 5, rho, sigma, result)
@show result
# [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661]
Libxc.xc_func_end(ptr)
Libxc.xc_func_free(ptr)
```

The same from the high-level interface:
```julia
using Libxc

rho = [0.1, 0.2, 0.3, 0.4, 0.5]
sigma = [0.2, 0.3, 0.4, 0.5, 0.6]
result = similar(rho)

# LDA exchange
lda_x = Functional(:lda_x)
evaluate_lda!(lda_x, rho, E=result)
@show result
# [-0.342809, -0.431912, -0.494416, -0.544175, -0.586194]

# GGA exchange
gga_x = Functional(:gga_x_pbe)
evaluate_gga!(gga_x, rho, sigma, E=result)
@show result
# [-0.452598, -0.478878, -0.520674, -0.561428, -0.598661]
```
