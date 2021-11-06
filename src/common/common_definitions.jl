"""

# CmdStanModels

Base model specialized in:

### Method
```julia
*  SampleModel                  : StanSample.jl
*  OptimizeModel                : StanOptimize.jl
*  VariationalModel             : StanVariational.jl
*  DiagnoseModel                : StanDiagnose.jl
```
""" 
abstract type CmdStanModels end

"""

Executable path corresponding to a source file, or a model.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
function executable_path(source_path::AbstractString)
    if Sys.iswindows()
        source_path =  source_path * ".exe"
    end
    source_path = source_path
end

executable_path(m::T) where T <: CmdStanModels =
    executable_path(m.tmpdir)

"""

Error thrown when a Stan model fails to compile. 

$(TYPEDEF)

# Extended help

Accessing fields directly is part of the API.

$(FIELDS)
"""
struct StanModelError <: Exception
    name::String
    message::String
end

function Base.showerror(io::IO, e::StanModelError)
    print(io, "\nError when compiling SampleModel ", e.name, ":\n",
          e.message)
end

"""

Ensure that a compiled model executable exists, and return its path.

$(SIGNATURES)

# Extended help

If compilation fails, a `StanModelError` is returned instead.

Internal, not exported.
"""
function ensure_executable(m::T) where T <: CmdStanModels
    @unpack cmdstan_home, exec_path = m
    error_output = IOBuffer()
    is_ok = cd(cmdstan_home) do
        success(pipeline(`make -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
                         stderr = error_output))
    end
    if is_ok
        exec_path
    else
        throw(StanModelError(m.name, String(take!(error_output))))
    end
end

"""

Compile a model, throwing an error if it failed.

$(SIGNATURES)
"""
function stan_compile(m::T) where T <: CmdStanModels
    ensure_executable(m)
    nothing
end

data_union = Union{Nothing, AbstractString, Dict, Array{T, 1} where T}
init_union = Union{Nothing, AbstractString, Dict, Array{T, 1} where T}

"""

Default `output_base` data files, in tmpdir.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
data_file_path(output_base::AbstractString, id::Int) = output_base * "_data_$(id).R"

"""

Default `output_base` init files, in tmpdir.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
init_file_path(output_base::AbstractString, id::Int) =
  output_base * "_init_$(id).R"

"""

Default `output_base` chain files, in tmpdir.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
sample_file_path(output_base::AbstractString, id::Int) =
  output_base * "_chain_$(id).csv"

"""

Default `output_base` for generated_quatities files, in tmpdir.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
generated_quantities_file_path(output_base::AbstractString, id::Int) = 
  output_base * "_generated_quantities_$(id).csv"

"""

Default `output_base` log files, in tmpdir.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
log_file_path(output_base::AbstractString, id::Int) =
  output_base * "_log_$(id).log"

"""

Default `output_base` diagnostic files, in tmpdir.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
diagnostic_file_path(output_base::AbstractString, id::Int) =
  output_base * "_diagnostic_$(id).csv"


"""

Generate a cmdstan command line (a run `cmd`).

$(SIGNATURES)

Internal, not exported.
"""
function stan_cmds(m::T, id::Integer; kwargs...) where {T <: CmdStanModels}
    append!(m.sample_file, [sample_file_path(m.output_base, id)])
    append!(m.log_file, [log_file_path(m.output_base, id)])
    if length(m.diagnostic_file) > 0
      append!(m.diagnostic_file, [diagnostic_file_path(m.output_base, id)])
    end
    cmdline(m, id)
end

"""

Update data or init R files.

$(SIGNATURES)

# Extended help

### Required arguments
```julia
* `m`                             : CmdStanModels object
* `input`                         : Input data or init values
* `num_chains`                    : Number of chains in model
* `fname_part="data"`             : Data or init R files to be created
```

Not exported.
"""
function update_R_files(m, input, num_chains, fname_part="data")
  
  m_field = fname_part == "data" ? m.data_file : m.init_file
  if typeof(input) <: NamedTuple || typeof(input) <: Dict
    for i in 1:num_chains
      stan_dump(m.output_base*"_$(fname_part)_$i.R", input, force=true)
      append!(m_field, [m.output_base*"_$(fname_part)_$i.R"])
    end
  elseif  typeof(input) <: Array
    if length(input) == num_chains
      for (i, d) in enumerate(input)
        stan_dump(m.output_base*"_$(fname_part)_$i.R", d, force=true)
        append!(m_field, [m.output_base*"_$(fname_part)_$i.R"])
      end
    else
      @info "Data vector length does not match number of chains,"
      @info "only first element in data vector will be used,"
      for i in 1:num_chains
        stan_dump(m.output_base*"_$(fname_part)_$i.R", input[1], force=true)
        append!(m_field, [m.output_base*"_$(fname_part)_$i.R"])
      end
    end
  elseif typeof(input) <: AbstractString && length(input) > 0
    for i in 1:num_chains
      cp(input, "$(m.output_base)_$(fname_part)_$i.R", force=true)
      append!(m_field, [m.output_base*"_$(fname_part)_$i.R"])
    end
  else
    error("\nUnrecognized input argument: $(typeof(input))\n")
  end
  
end

"""
Helper function for the (deprecated) diagnostics file generation.

$(SIGNATURES)

# Extended help

I am not aware the diagnostic files contain other info then the regular .csv files.
Currently I have not disabled this functionality. Please let me know if this
feature should be included/enabled.
"""
function setup_diagnostics(m, num_chains)  
  for i in 1:num_chains
    append!(m.diagnostic_file, [m.output_base*"_diagnostic_$i.log"])
  end  
end

