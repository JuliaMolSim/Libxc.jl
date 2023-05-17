# Libxc.jl

| **Build Status**                                                      |  **License**                     |
|:--------------------------------------------------------------------- |:-------------------------------- |
| ![][ci-img] [![][cigpu-img]][cigpu-url] [![][ccov-img]][ccov-url]  | [![][license-img]][license-url]  |

[ci-img]: https://github.com/JuliaMolSim/Libxc.jl/workflows/CI/badge.svg

[cigpu-img]: https://git.uni-paderborn.de/herbstm/Libxc.jl/badges/master/pipeline.svg?key_text=GPU%20CI
[cigpu-url]: https://git.uni-paderborn.de/herbstm/Libxc.jl/-/pipelines

[ccov-img]: https://codecov.io/gh/JuliaMolSim/Libxc.jl/branch/master/graph/badge.svg?token=ZL7RUND4YE
[ccov-url]: https://codecov.io/gh/JuliaMolSim/Libxc.jl

[license-img]: https://img.shields.io/github/license/JuliaMolSim/Libxc.jl.svg?maxAge=2592000
[license-url]: https://github.com/JuliaMolSim/Libxc.jl/blob/master/LICENSE

This package provides Julia bindings to the
[libxc](https://tddft.org/programs/libxc/) library
for common exchange-correlation functionals in density-functional theory.
At least **Julia 1.7** is required.

## Usage
Install the library from Julia as usual:
```julia
import Pkg
Pkg.add("Libxc")
```
and then for example:
```julia
using Libxc

rho = [0.1, 0.2, 0.3, 0.4, 0.5]
sigma = [0.2, 0.3, 0.4, 0.5, 0.6]

# LDA exchange
lda_x = Functional(:lda_x)
result = evaluate(lda_x, rho=rho)
@show result
# result = (vrho = [-0.457078 -0.575882 -0.659220 -0.725566 -0.781592],
#           zk = [-0.342808, -0.43191, -0.49441, -0.544174, -0.586194])

# GGA exchange
gga_x = Functional(:gga_x_pbe, n_spin=1)
result = evaluate(gga_x, rho=rho, sigma=sigma, derivative=0)
@show result
# result = (zk = [-0.452597, -0.478877, -0.520674, -0.561427, -0.598661],)
```

## Status
Full support for evaluating LDA, GGA and meta-GGA functionals
on CPUs as shown above.

Recently GPU support has been added. Whenever `evaluate` is called
with `CuArray`s, the computation will automatically be done with the CUDA
version of libxc. Currently only CUDA 11 is supported,
so you need to enforce using CUDA 11 explicitly:
```julia
using CUDA
CUDA.set_runtime_version!(v"11.8")
```

Hybrid or range-separated hybrids and VV10-type functionals
export parameters required in the host programs as properties of the `Functional`
Julia object. For example
```julia
b3lyp = Functional(:hyb_gga_xc_b3lyp)
@show b3lyp.exx_coefficient
# b3lyp.exx_coefficient = 0.2
```
See also the [xc-info.jl](example/xc-info.jl) example (modelled after the
`xc-info` executable shipped with libxc).

Some advanced Libxc features (custom functional combinations, setting external
parameters etc.) are not yet supported in the Julia wrapper. If you need those
you can, however, talk to libxc directly using the low-level C-like interface,
see the file [src/gen/api.jl](src/gen/api.jl).
This file is automatically generated from the libxc source code and
offers all functions of the public interface as `ccall` wrappers.
