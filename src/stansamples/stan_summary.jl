"""

Create a `name`_summary.csv file. 

$(SIGNATURES)

# Extended help

### Required arguments
```julia
* `model::SampleModel             : SampleModel
```

### Optional arguments
```julia
* `printsummary=false             : Display summary
```

After completion a ..._summary.csv file has been created.
This file can be read as a DataFrame in by `df = read(summary(model))`

"""
function stan_summary(m::T, printsummary=false) where {T <: CmdStanModels}
  
  #local csvfile
  if hasproperty(m, :num_cpp_chains)
    n_chains = max(m.num_chains, m.num_cpp_chains)
  else
    n_chains = m.num_chains
  end
  
  samplefiles = String[]
  hasproperty(m, :num_cpp_chains) && (cpp_chains = m.num_cpp_chains)
  julia_chains = m.num_chains

  # Read .csv files and return a3d[n_samples, parameters, n_chains]
  if hasproperty(m, :use_cpp_chains) && m.use_cpp_chains
    for i in 1:m.num_chains   # Number of exec processes
        push!(samplefiles, "$(m.output_base)_chain_1_$(i).csv")
    end
  else
    for i in 1:m.num_chains   # Number of exec processes
      push!(samplefiles, "$(m.output_base)_chain_$(i).csv")
    end
  end
  #println(samplefiles)

  try
    pstring = joinpath("$(m.cmdstan_home)", "bin", "stansummary")
    if Sys.iswindows()
      pstring = pstring * ".exe"
    end
    csvfile = "$(m.output_base)_summary.csv"
    isfile(csvfile) && rm(csvfile)
    cmd = `$(pstring) -c $(csvfile) $(par(samplefiles))`
    outb = IOBuffer()
    run(pipeline(cmd, stdout=outb));
    if printsummary
      cmd = `$(pstring) $(par(samplefiles))`
      resfile = open(cmd; read=true);
      print(read(resfile, String))
    end
  catch e
    println(e)
  end
  
  return
  
end

