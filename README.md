# StanBase

| **Project Status**          |  **Build Status** |
|:---------------------------:|:-----------------:|
|![][project-status-img] | ![][CI-build] |

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://stanjulia.github.io/StanBase.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stanjulia.github.io/StanBase.jl/stable

[CI-build]: https://github.com/stanjulia/StanBase.jl/workflows/CI/badge.svg?branch=master

[issues-url]: https://github.com/stanjulia/StanBase.jl/issues

[project-status-img]: https://img.shields.io/badge/lifecycle-wip-orange.svg

## Introduction

This package contains common components for several method packages wrapping Stan's `cmdstan` executable. 

Stan `methods` supported are in StanSample, StanOptimize, StanVariational, StanDiagnose and `generated_quantities` (included in StanSample.jl). 

A new package, DiffEqBayesStan.jl has been added to focus on DifferentialEquations and Stan.

Another package, StanQuap.jl, provides a quadratic approximation using StanOptimize.jl and StanSample.jl as used in the early chapters of [StatisticalRethinking](https://github.com/StatisticalRethinkingJulia).

These six application packages support all features and options currently available in the `cmdstan` executable.

The intention is that users of Stan's `cmdstan` executable will never have to install Stanbase.jl, they can simply install any of the application packages listed [here](https://github.com/StanJulia). 

## Installation

This package is registered. Install it with:
```Julia
pkg> add StanBase
```

This package is loaded automatically when `using ...` any of the Stan method packages.

This package is structured somewhat similar to Tamas Papp's [StanRun.jl](https://github.com/tpapp/StanRun.jl) package. It also uses StanDump.jl. 

This and all the method packages need a working [cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify in `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["JULIA_CMDSTAN_HOME"] = expanduser("~/src/cmdstan-2.19.1/") # replace with your path
```
