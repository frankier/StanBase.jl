"""
$(SIGNATURES)

Executable path corresponding to a source file, or a model.

Internal, not exported.
"""
function executable_path(source_path::AbstractString)
    replace_ext(source_path, Sys.iswindows() ? ".exe" : "")
end

executable_path(model::T) where T <: CmdStanModels =
    executable_path(model.tmpdir)

"""
$(TYPEDEF)

Error thrown when a Stan model fails to compile. Accessing fields directly is part of the
API.

$(FIELDS)
"""
struct StanModelError{T <: CmdStanModels} <: Exception
    model::T
    message::String
end

function Base.showerror(io::IO, e::StanModelError)
    print(io, "error when compiling ", e.model, ":\n",
          e.message)
end

"""
$(SIGNATURES)

Ensure that a compiled model executable exists, and return its path.

If compilation fails, a `StanModelError` is returned instead.

Internal, not exported.
"""
function ensure_executable(model::T) where T <: CmdStanModels
    @unpack cmdstan_home = model
    exec_path = executable_path(model)
    error_output = IOBuffer()
    is_ok = cd(cmdstan_home) do
        success(pipeline(`make -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
                         stderr = error_output))
    end
    if is_ok
        exec_path
    else
        throw(StanModelError(model, String(take!(error_output))))
    end
end

