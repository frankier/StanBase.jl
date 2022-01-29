# StanBase v4

| **Project Status**          |  **Build Status** |
|:---------------------------:|:-----------------:|
|![][project-status-img] | ![][CI-build] |

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://stanjulia.github.io/StanBase.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stanjulia.github.io/StanBase.jl/stable

[CI-build]: https://github.com/stanjulia/StanBase.jl/workflows/CI/badge.svg?branch=master

[issues-url]: https://github.com/stanjulia/StanBase.jl/issues

[project-status-img]: https://img.shields.io/badge/lifecycle-stable-green.svg

## Introduction

This package contains common components for several method packages wrapping Stan's `cmdstan` executable. 

Stan `methods` supported are in StanSample, StanOptimize, StanVariational, StanDiagnose and `generated_quantities` (included in StanSample.jl). 

A new package, DiffEqBayesStan.jl has been added to focus on DifferentialEquations and Stan.

Another package, StanQuap.jl, provides a quadratic approximation using StanOptimize.jl and StanSample.jl as used in the early chapters of [StatisticalRethinking](https://github.com/StatisticalRethinkingJulia).

These six application packages support all features and options currently available in the `cmdstan` executable.

## Installation

This package is registered. Install it with:
```Julia
pkg> add StanBase
```
The intention is that users of Stan's `cmdstan` executable will never have to install Stanbase.jl, they can simply install any of the application packages listed [here](https://github.com/StanJulia). 

This and all the method packages need a working [cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify in `CMDSTAN`, eg in your `~/.julia/config/startup.jl` have a line like:
```julia
ENV["CMDSTAN"] = expanduser("~/.../cmdstan/") # replace with your path
```

This package is structured somewhat similar to Tamas Papp's [StanRun.jl](https://github.com/tpapp/StanRun.jl) package. 

## Versions

StanBase.jl v4 supports Stan.jl v9 and StanSample v6 which use C++ level threads by default. This has major consequences for StanSample.jl and Stan.jl (explained in the documentation of Stan.jl v9 and in the on-line help in StanSample.jl v6). As such it is a breaking update.

StannBase.jl versions < v4.0.0 used StanDump.jl to create data.R and init.R files. It is no longer clear if .R files will be supported in future version. Certainly with cmdstan-2.28.2 I have seen error messages when using init.R files. Hence version 4+ uses by default JSON3.jl for this purpose. As JSON3.jl currently doesn't handle multidimensional arrays properly, for now I have added a positional `use_json=true` argument to e.g. stan_sample().

