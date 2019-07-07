import Base: show

"""

# CmdStanModel

Base model specialized in:

### Method
```julia
*  CmdStanSampleModel                  : StanSample.jl
*  CmdStanOptimizeModel                : StanOptimize.jl
*  CmdStanVariationalModel          :   StanVariational.jl

Not yet done:

*  CmdStanDiagnoseModel                : StanDiagnose.jl
*  CmdStanGenerate_QuamtitiesModel     : StanGenerate_Quantities.jl
```
""" 
abstract type CmdStanModel end

"""

# CmdStanMethod

### Method
```julia
*  Sample::Method                      : Sampling
*  Optimize::Method                    : Optimization
*  Diagnose::Method                    : Diagnostics
*  Variational::Method                 : Variational Bayes
*  Generate_Quamtities:Method          : Generate_Quantities
```
""" 
abstract type CmdStanMethod end

"""

# Cmdline

### Method
```julia
*  SampleCmdline                       : Sampling
*  OptimizeCmdline                     : Optimization
*  DiagnoseCmdline                     : Diagnostics
*  VariationalCmdline                  : Variational Bayes
*  Generate_QuamtitiesCmdline          : Generate_Quantities
```
""" 
abstract type Cmdline end

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

