"""
Helper infrastructure to compile and sample models using `cmdstan`.

"""
module StanBase

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF
using Unicode, DelimitedFiles, Distributed
using MCMCChains
using Parameters

using StanDump

Int64(VERSION.minor) < 3 && include("utils/findall.jl")
include("stanmodel/cmdstan_home.jl")
include("stanmodel/shared_fields.jl")
include("stanmodel/top_level_types.jl")
include("stanmodel/help_types.jl")
include("stanmodel/HelpModel.jl")
include("stanmodel/update_model_file.jl")
include("stanmodel/number_of_chains.jl")
include("stanrun/executable.jl")
include("stanrun/cmdline.jl")
include("stanrun/stan_sample.jl")
include("stansamples/stan_summary.jl")
include("stansamples/read_summary.jl")
include("utils/par.jl")

"""
The directory which contains the cmdstan executables such as `bin/stanc` and
`bin/stansummary`. Inferred from the environment variable `JULIA_CMDSTAN_HOME` or `ENV["JULIA_CMDSTAN_HOME"]`
when available.
If these are not available, use `set_cmdstan_home!` to set the value of CMDSTAN_HOME.
Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`
Executing `versioninfo()` will display the value of `JULIA_CMDSTAN_HOME` if defined.
"""
CMDSTAN_HOME=""

function __init__()
  global CMDSTAN_HOME = if isdefined(Main, :JULIA_CMDSTAN_HOME)
    Main.JULIA_CMDSTAN_HOME
  elseif haskey(ENV, "JULIA_CMDSTAN_HOME")
    ENV["JULIA_CMDSTAN_HOME"]
  elseif haskey(ENV, "CMDSTAN_HOME")
    ENV["CMDSTAN_HOME"]
  else
    @warn("Environment variable CMDSTAN_HOME not set. Use set_cmdstan_home!.")
    ""
  end
end

"""Set the path for the `CMDSTAN_HOME` environment variable.
Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`
"""
set_cmdstan_home!(path) = global CMDSTAN_HOME = path

stan_help = stan_sample

export
  @shared_fields_stanmodels,
  CmdStanModels,
  HelpModel,
  cmdline,
  stan_help,
  stan_sample,
  read_summary,
  stan_summary,
  get_cmdstan_home,
  set_cmdstan_home!,
  findall

end # module
