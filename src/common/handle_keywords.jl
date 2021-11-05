"""

Handle model specific keywords in kwargs argument in stan_run(model; kwargs...).

$(SIGNATURES)

"""
function handle_keywords!(m::T, kwrds) where { T <: CmdStanModels}

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
end
