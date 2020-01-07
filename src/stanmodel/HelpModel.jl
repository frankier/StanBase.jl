import Base.show
using Random
using StanRun

mutable struct HelpModel <: CmdStanModels	
    @shared_fields_stanmodels
    method::Help
end

function HelpModel(
  name::AbstractString,
  model::AbstractString,
  n_chains=[4];
  seed = RandomSeed(),
  init = Init(),
  output = Output(),
  tmpdir = mktempdir(),
  method = Help(),
  kwargs...)
  
  !isdir(tmpdir) && mkdir(tmpdir)
  
  StanBase.update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))
  sm = StanModel(joinpath(tmpdir, "$(name).stan"))
  
  output_base = tmpdir
  exec_path = ensure_executable(sm)
  
  stan_compile(sm)
  
  HelpModel(name, model, n_chains, seed, init, output,
    tmpdir, tmpdir, exec_path, String[], String[], 
    Cmd[], String[], String[], String[], false, false,
    get_cmdstan_home(), method)
end

function help_model_show(io::IO, m, compact::Bool)
  println(io, "  name =                    \"$(m.name)\"")
  println(io, "  method =                  $(m.method)")
  println(io, "  n_chains =                $(get_n_chains(m))")
  println(io, "  output =                  Output()")
  println(io, "    file =                    \"$(split(m.output.file, "/")[end])\"")
  println(io, "    diagnostics_file =        \"$(split(m.output.diagnostic_file, "/")[end])\"")
  println(io, "    refresh =                 $(m.output.refresh)")
  println(io, "  tmpdir =                  \"$(m.tmpdir)\"")
end

show(io::IO, m::HelpModel) = help_model_show(io, m, false)
