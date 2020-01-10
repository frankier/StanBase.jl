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
  set_cmdstan_home,
  findall

end # module
