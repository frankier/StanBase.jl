data_union = Union{Nothing, AbstractString, Dict, Array{T, 1} where T}
init_union = Union{Nothing, StanBase.Init, AbstractString, Dict, Array{T, 1} where T}

"""
$(SIGNATURES)

Default `output_base` data files, in tmpdir. Internal, not exported.
"""
data_file_path(output_base::AbstractString, id::Int) = output_base * "_data_$(id).R"

"""
$(SIGNATURES)

Default `output_base` init files, in tmpdir. Internal, not exported.
"""
init_file_path(output_base::AbstractString, id::Int) = output_base * "_init_$(id).R"

"""
$(SIGNATURES)

Default `output_base` chain files, in tmpdir. Internal, not exported.
"""
sample_file_path(output_base::AbstractString, id::Int) = output_base * "_chain_$(id).csv"

"""
$(SIGNATURES)

Default `output_base` chain files, in tmpdir. Internal, not exported.
"""
generated_quantities_file_path(output_base::AbstractString, id::Int) = 
  output_base * "_generated_quantities_$(id).csv"

"""
$(SIGNATURES)

Default `output_base` log files, in tmpdir. Internal, not exported.
"""
log_file_path(output_base::AbstractString, id::Int) = output_base * "_log_$(id).log"

"""
$(SIGNATURES)

Default `output_base` diagnostic files, in tmpdir. Internal, not exported.
"""
diagnostic_file_path(output_base::AbstractString, id::Int) = output_base * "_diagnostic_$(id).csv"

"""
# stan_sample 

Execute the method contained in a CmdStanModel.

### Required arguments
```julia
* `model::AbstractString`              : CmdStanModel subtype
```

### Optional arguments
```julia
* `n_chains=4`                         : Number of chains
* `init`                               : Init dict
* `data`                               : Data dict
* `diagnostics=false`                  : Generate diagnost files (deprecated?)
```
### Returns
```julia
* `rc`                                 Return code, 0 is success
```
"""
function stan_sample(model::T; kwargs...) where {T <: CmdStanModels}

  n_chains = 4
  diagnostics = false
    
  if :n_chains in keys(kwargs) 
    n_chains = kwargs[:n_chains]
    set_n_chains(model, n_chains)
  end

  # Diagnostics files requested?
  if :diagnostics in keys(kwargs)
    diagnostics = kwargs[:diagnostics]
    setup_diagnostics(model, get_n_chains(model))
  end

  # Remove existing sample files
  for id in 1:get_n_chains(model)
    sfile = sample_file_path(model.output_base, id)
    isfile(sfile) && rm(sfile)
  end

  :init in keys(kwargs) && update_R_files(model, kwargs[:init], n_chains, "init")
  :data in keys(kwargs) && update_R_files(model, kwargs[:data], n_chains, "data")

  cmds_and_paths = [stan_cmd_and_paths(model, id; kwargs...)
                    for id in 1:get_n_chains(model)]

  pmap(cmds_and_paths) do cmd_and_path
      cmd, (sample_path, log_path) = cmd_and_path
      run(cmd)
  end
    
end

"""
$(SIGNATURES)

Run a Stan command. Internal, not exported.
"""
function stan_cmd_and_paths(model::T, id::Integer; kwargs...) where {T <: CmdStanModels}
    append!(model.sample_file, [sample_file_path(model.output_base, id)])
    append!(model.log_file, [log_file_path(model.output_base, id)])
    if length(model.diagnostic_file) > 0
      append!(model.diagnostic_file, [diagnostic_file_path(model.output_base, id)])
    end
    append!(model.cmds, [cmdline(model, id)])
    pipeline(model.cmds[id]; stdout=model.log_file[id]), (model.sample_file[id], model.log_file[id])
    
end

function update_R_files(model, input, n_chains, fname_part="data")
  
  model_field = fname_part == "data" ? model.data_file : model.init_file
  if typeof(input) <: NamedTuple || typeof(input) <: Dict
    for i in 1:n_chains
      stan_dump(model.output_base*"_$(fname_part)_$i.R", input, force=true)
      append!(model_field, [model.output_base*"_$(fname_part)_$i.R"])
    end
  elseif  typeof(input) <: Array
    if length(input) == n_chains
      for (i, d) in enumerate(input)
        stan_dump(model.output_base*"_$(fname_part)_$i.R", d, force=true)
        append!(model_field, [model.output_base*"_$(fname_part)_$i.R"])
      end
    else
      @info "Data vector length does not match number of chains,"
      @info "only first element in data vector will be used,"
      for i in 1:n_chains
        stan_dump(model.output_base*"_$(fname_part)_$i.R", input[1], force=true)
        append!(model_field, [model.output_base*"_$(fname_part)_$i.R"])
      end
    end
  elseif typeof(input) <: AbstractString && length(input) > 0
    for i in 1:n_chains
      cp(input, "$(model.output_base)_$(fname_part)_$i.R", force=true)
      append!(model_field, [model.output_base*"_$(fname_part)_$i.R"])
    end
  else
    error("\nUnrecognized input argument: $(typeof(input))\n")
  end
  
end

function setup_diagnostics(model, n_chains)
  
  for i in 1:n_chains
    append!(model.diagnostic_file, [model.output_base*"_diagnostic_$i.log"])
  end
  
end
