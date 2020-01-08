const CMDSTAN_HOME_VAR = "JULIA_CMDSTAN_HOME"

function get_cmdstan_home()
    get(ENV, CMDSTAN_HOME_VAR) do
        throw(ErrorException("The environment variable $CMDSTAN_HOME_VAR needs to be set."))
    end
end

