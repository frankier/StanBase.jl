import Base: show

"""

# CmdStanModels

Base model specialized in:

### Method
```julia
*  SampleModel                         : StanSample.jl
*  OptimizeModel                       : StanOptimize.jl
*  VariationalModel                     : StanVariational.jl

Not yet done:

*  DiagnoseModel                       : StanDiagnose.jl
*  Generate_QuamtitiesModel            : StanGenerate_Quantities.jl
```
""" 
abstract type CmdStanModels end

"""

# CmdStanMethods

### Method
```julia
*  Sample                              : Sampling
*  Optimize                            : Optimization
*  Diagnose                            : Diagnostics
*  Variational                         : Variational Bayes
*  Generate_Quamtities                 : Generate_Quantities
```
""" 
abstract type CmdStanMethods end

"""

# Cmdlines

### Method
```julia
*  SampleCmdline                       : Sampling
*  OptimizeCmdline                     : Optimization
*  DiagnoseCmdline                     : Diagnostics
*  VariationalCmdline                  : Variational Bayes
*  Generate_QuamtitiesCmdline          : Generate_Quantities
```
""" 
abstract type Cmdlines end

"""

# Random

Random number generator seed value

### Method
```julia
Random(;seed=-1)
```
### Optional arguments
```julia
* `seed::Int`           : Starting seed value
```
""" 
struct Random
  seed::Int64
end
Random(;seed::Number=-1) = Random(seed)

"""

# Init

Default bound for parameter initial value interval (if not found in init file)

### Method
```julia
Init(;bound=2)
```
### Optional arguments
```julia
* `bound::Number`           : Set interval to [-bound, bound]
```
""" 
struct Init
  bound::Int64
end
Init(;bound::Int64=2) = Init(bound)

"""

# Output

Default settings for output portion in cmdstan command

### Method
```julia
Output(;file="", diagnostics_file="", refresh=100)
```
### Optional arguments
```julia
* `fikle::AbstractString`              : File used to store draws
* `diagnostics_fikle::AbstractString`  : File used to store diagnostics
* `refresh::Int64`                     : Output refresh rate
```
""" 
mutable struct Output
  file::String
  diagnostic_file::String
  refresh::Int64
end
Output(;file="", diagnostic_file="", refresh=100) =
  Output(file, diagnostic_file, refresh)

