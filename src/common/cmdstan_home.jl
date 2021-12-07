
const CMDSTAN_HOME_VAR = if haskey(ENV, "CMDSTAN")
    "CMDSTAN"
elseif haskey(ENV, "JULIA_CMDSTAN_HOME")
    "JULIA_CMDSTAN_HOME"
end

"""

Set the path for `CMDSTAN_HOME`.

$(SIGNATURES)

# Extended help

Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`
"""
set_cmdstan_home!(path) = global CMDSTAN_HOME = path
