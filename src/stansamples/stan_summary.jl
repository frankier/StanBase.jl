"""

# Method stan_summary

Display cmdstan summary 

### Method
```julia
stan_summary(
  model::SampleModel,
  CmdStanDir=CMDSTAN_HOME
)
```
### Required arguments
```julia
* `model::SampleModel             : Stanmodel
* `file::String`                : Name of file with samples
```

### Optional arguments
```julia
* CmdStanDir=CMDSTAN_HOME       : cmdstan directory for stansummary program
```

### Related help
```julia
?Stan.stan                      : Execute a StanModel
```
"""
function stan_summary(
  model::T; 
  printsummary=false) where {T <: CmdStanModels}
  
  #local csvfile
  n_chains = get_n_chains(model)
  
  samplefiles = String[]
  for i in 1:n_chains
    push!(samplefiles, "$(model.output_base)_chain_$(i).csv")
  end
  try
    pstring = joinpath("$(model.cmdstan_home)", "bin", "stansummary")
    csvfile = "$(model.output_base)_summary.csv"
    isfile(csvfile) && rm(csvfile)
    cmd = `$(pstring) --csv_file=$(csvfile) $(par(samplefiles))`
    run(cmd)
    if printsummary
      cmd = `$(pstring) $(par(samplefiles))`
      resfile = open(cmd; read=true)
      print(read(resfile, String))
    end
  catch e
    println(e)
  end
  
  return
  
end

