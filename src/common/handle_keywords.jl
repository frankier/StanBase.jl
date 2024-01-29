"""

Handle keywords in kwargs argument in stan_run(model; kwargs...).

$(SIGNATURES)

In this call `kwrds` are all keyword arguments part of the call
to e.g. `stan_sample(; kwargs...)`.

"""
function handle_keywords!(m::T, kwrds) where {T <: CmdStanModels}

    model_keywords = fieldnames(typeof(m))
    excluded_model_keywords = [
        :name, :model, :data, :init, :output_base, :tmpdir, :exec_path,
        :data_file, :init_file, :cmds, :sample_file, :log_file,
        :diagnostic_file, :cmdstan_home
    ]
    accepted_keywords = setdiff(model_keywords, excluded_model_keywords)

    for kwrd in keys(kwrds)
        if !(kwrd in [:data, :init])
            if kwrd in accepted_keywords
                if  kwrd == :seed && typeof(kwrds[kwrd]) == Vector{Int}
                    m.seed = kwrds[kwrd]
                else
                    setfield!(m, kwrd, kwrds[kwrd])
                end
            else
                @info "Allowed keywords: $(accepted_keywords)"
                if kwrd in excluded_model_keywords
                    @warn "Keyword \"$(Symbol(kwrd))\" not allowed. Ignored."
                else
                    @warn "Keyword \"$(Symbol(kwrd))\" not in model. Ignored."
                end
            end
        end
    end

    if hasproperty(m , :use_cpp_chains) && m.check_num_chains
        if m.use_cpp_chains
            m.num_cpp_chains = m.num_chains
            m.num_julia_chains = 1
        else
            m.num_julia_chains = m.num_chains
            m.num_cpp_chains = 1
        end
    elseif hasproperty(m , :use_cpp_chains) && m.use_cpp_chains
        m.num_chains = m.num_cpp_chains * m.num_julia_chains
    end

end
