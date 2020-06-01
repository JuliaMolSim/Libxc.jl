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

## Usage
Install the library from Julia as usual:
```sh
] add Libxc
```
and then for example:
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
