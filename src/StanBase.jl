"""

Helper infrastructure package to compile and sample models using Stan's `cmdstan`.
Not really intended to be called directly by a user.

"""
module StanBase

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF
using Unicode, DelimitedFiles
using DataFrames, CSV, Parameters, NamedTupleTools

using JSON

include("common/cmdstan_home.jl")
include("common/common_definitions.jl")
include("common/handle_keywords.jl")
include("common/update_model_file.jl")
# include("common/update_R_files.jl")
include("common/update_json_files.jl")
include("common/par.jl")

#include("stansamples/stan_summary.jl")
#include("stansamples/read_summary.jl")

"""
The directory which contains the cmdstan executables such as `bin/stanc` and
`bin/stansummary`. 

# Extended help

Inferred from the environment variable `CMDSTAN` or `ENV["CMDSTAN"]`
when available.

If these are not available, use `set_cmdstan_home!` to set the value of CMDSTAN_HOME.

Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`

Executing `versioninfo()` will display the value of `CMDSTAN` if defined.
"""
CMDSTAN_HOME=""

function __init__()
  global CMDSTAN_HOME = if haskey(ENV, "CMDSTAN")
    ENV["CMDSTAN"]
  elseif isdefined(Main, :CMDSTAN)
    Main.CMDSTAN
  elseif haskey(ENV, "JULIA_CMDSTAN_HOME")
    ENV["JULIA_CMDSTAN_HOME"]
  elseif haskey(ENV, "CMDSTAN_HOME")
    ENV["CMDSTAN_HOME"]
  else
    @warn("Environment variable CMDSTAN_HOME not set. Use set_cmdstan_home!.")
    ""
  end
end

export
  CMDSTAN_HOME,
  set_cmdstan_home!,
  make_command,
  CmdStanModels,
  StanModelError

end # module
