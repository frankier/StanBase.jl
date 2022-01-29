"""

Handle keywords in kwargs argument in stan_run(model; kwargs...).

$(SIGNATURES)

Note: Currently I do not suggest to use both C++ level chains and Julia
level chains. By default, if `num_chains > 1` this method will set
`num_cpp_chains` to 1 and a message will be displayed. Set the
postional `check_num_chains` argument to `false` to prevent this.

"""
function handle_keywords!(m::T, kwrds,
    check_num_chains=true) where {T <: CmdStanModels}

    model_keywords = fieldnames(typeof(m))
    excluded_model_keywords = [
        :name, :model, :data, :init, :output_base, :tmpdir, :exec_path,
        :data_file, :init_file, :cmds, :sample_file, :log_file,
        :diagnostic_file, :cmdstan_home
    ]
    accepted_keywords = setdiff(model_keywords, excluded_model_keywords)
    #println(accepted_keywords)

    for kwrd in keys(kwrds)
        if !(kwrd in [:data, :init])
            if kwrd in accepted_keywords
                setfield!(m, kwrd, kwrds[kwrd])    
            else
                println("\nAllowed keywords: $(accepted_keywords)")
                if kwrd in excluded_model_keywords
                    println("\nKeyword \"$(Symbol(kwrd))\" not allowed. Ignored.")
                else
                    println("\nKeyword \"$(Symbol(kwrd))\" not in model. Ignored.")
                end
            end
        end
    end
    if check_num_chains && hasproperty(m, :num_cpp_chains)
        if m.num_chains > 1 && m.num_cpp_chains >1
            @info "If num_chains > 1, num_cpp_chains must be set to 1."
            m.num_cpp_chains = 1
            @info "Set num_cpp_chain = 1."
        end
    end
end
