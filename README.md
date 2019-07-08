# StanBase.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/goedman/StanBase.jl.svg?branch=master)](https://travis-ci.com/goedman/StanBase.jl)
[![codecov.io](http://codecov.io/github/goedman/StanBase.jl/coverage.svg?branch=master)](http://codecov.io/github/goedman/StanBase.jl?branch=master)

## Important note

I'm not planning to go this route. It just makes the setup too complcated.

## Installation

Common components for several application packages wrapping Stan's `cmdstan` executable. Currently 3 out of 5 are available, i.e. StanSample, StanOptimize and StanVariational. Not yet done are StanDiagnose and StanGeneratedQuantities.

These 5 application packages support all features and options currently available in the `cmdstan` exacutable.

This package is not registered yet. Install with

```julia
pkg> add https://github.com/StanJulia/StanBase.jl
```

This package is loaded when `using ...` any of the application packages.

This package is derived from Tamas Papp's [StanRun.jl](https://github.com/tpapp/StanRun.jl) package. It also uses StanDump.jl and StanSamples.jl. 

The application packages need a working [cmdctan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify in `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["JULIA_CMDSTAN_HOME"] = expanduser("~/src/cmdstan-2.19.1/") # replace with your path
```
