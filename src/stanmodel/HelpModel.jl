import Base.show

mutable struct HelpModel <: CmdStanModels	
    @shared_fields_stanmodels
    method::Any
end

function HelpModel(
  name::AbstractString,
  model::AbstractString,
  n_chains=[4];
  random = StanBase.Random(),
  init = StanBase.Init(),
  output = StanBase.Output(),
  tmpdir = mktempdir(),
  method = StanBase.Help(),
  kwargs...)
  
  !isdir(tmpdir) && mkdir(tmpdir)
  
  StanBase.update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))
  sm = StanModel(joinpath(tmpdir, "$(name).stan"))
  
  output_base = StanRun.default_output_base(sm)
  exec_path = StanRun.ensure_executable(sm)
  
  stan_compile(sm)
  
  HelpModel(name, model, n_chains, random, init, output,
    tmpdir, output_base, exec_path, String[], String[], 
    Cmd[], String[], String[], String[], false, false, sm, method)
end

function help_model_show(io::IO, m, compact::Bool)
  println("  name =                    \"$(m.name)\"")
  println("  n_chains =                $(get_n_chains(m))")
  println("  output =                  Output()")
  println("    file =                    \"$(m.output.file)\"")
  println("    diagnostics_file =        \"$(m.output.diagnostic_file)\"")
  println("    refresh =                 $(m.output.refresh)")
  println("  tmpdir =                  \"$(m.tmpdir)\"")
  show(io, m.method, compact)
end

show(io::IO, m::HelpModel) = help_model_show(io, m, false)
