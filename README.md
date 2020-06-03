# Libxc.jl

| **Build Status**                                                      |  **License**                     |
|:--------------------------------------------------------------------- |:-------------------------------- |
| [![][travis-img]][travis-url] ![][winci-img] [![][cov-img]][cov-url]  | [![][license-img]][license-url]  |

[travis-img]: https://travis-ci.com/JuliaMolSim/Libxc.jl.svg?branch=master
[travis-url]: https://travis-ci.com/JuliaMolSim/Libxc.jl

[winci-img]: https://github.com/JuliaMolSim/Libxc.jl/workflows/Windows%20tests/badge.svg

[cov-img]: https://coveralls.io/repos/JuliaMolSim/Libxc.jl/badge.svg?branch=master&service=github
[cov-url]: https://coveralls.io/github/JuliaMolSim/Libxc.jl?branch=master

[license-img]: https://img.shields.io/github/license/JuliaMolSim/Libxc.jl.svg?maxAge=2592000
[license-url]: https://github.com/JuliaMolSim/Libxc.jl/blob/master/LICENSE

This package provides Julia bindings to the
[libxc](https://tddft.org/programs/libxc/) library
for common exchange-correlation functionals in density-functional theory.

## Usage (High-level interface)
Install the library from Julia as usual:
```sh
] add Libxc
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

### Status
Full support for evaluating LDA, GGA and meta-GGA functionals
as shown above. No support for hybrid or range-separated
functionals yet. For those you need to talk to libxc directly
using the low-level interface.

## Low-level interface
All functions from libxc are available in Julia in a C-like interface
automatically generated from the libxc source code. See the file
[src/gen/libxc.jl](src/gen/libxc.jl) for the full list.
