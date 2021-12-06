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

make_string = "make"

if Sys.iswindows()
    make_command =  "mingw32-" * make_string
end

"""
set_make_string!()

Update the name of the make command, e.g. "make" or "minw32-make".
By default make_string == "make" and on Windows make_string == "ming32-make".

Display value as `StanBase.make_string`.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
function set_make_string!(str = make_string)
    make_string = str
end

"""
make command.

$(SIGNATURES)

# Extended help

Internal, not exported.
"""
function make_command(str = make_string)
    str
end

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
        success(pipeline(`$(make_command()) -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
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

