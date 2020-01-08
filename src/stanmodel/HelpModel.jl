import Base.show
using Random
#using StanRun

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
  
  output_base = joinpath(tmpdir, name)
  exec_path = output_base
  cmdstan_home = get_cmdstan_home()

  error_output = IOBuffer()
  is_ok = cd(cmdstan_home) do
      success(pipeline(`make -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
                       stderr = error_output))
  end
  if !is_ok
      throw(StanModelError(model, String(take!(error_output))))
  end
  
  HelpModel(name, model, n_chains, seed, init, output,
    tmpdir, output_base, exec_path, String[], String[], 
    Cmd[], String[], String[], String[], false, false,
    cmdstan_home, method)
end

function help_model_show(io::IO, m, compact::Bool)
  println(io, "  name =                    \"$(m.name)\"")
  println(io, "  method =                  $(m.method)")
  println(io, "  n_chains =                $(get_n_chains(m))")
  println(io, "  tmpdir =                  \"$(m.tmpdir)\"")
end

show(io::IO, m::HelpModel) = help_model_show(io, m, false)
