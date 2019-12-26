using DataFrames, MCMCChains, CSV

"""

# read_summary

Read summary output file created by stansummary. 

### Method
```julia
read_summary(m)
```

### Required arguments
```julia
* `m`    : A Stan model object, e.g. SampleModel
```

"""
function read_summary(m::T) where {T <: CmdStanModels}

  fname = "$(m.output_base)_summary.csv"
  !isfile(fname) && stan_summary(m)

  df = CSV.read(fname, delim=",", comment="#")
  
  cnames = lowercase.(convert.(String, String.(names(df))))
  cnames[1] = "parameters"
  cnames[4] = "std"
  cnames[8] = "ess"
  rename!(df, Symbol.(cnames), makeunique=true)
  df[!, :parameters] = Symbol.(df[!, :parameters])
  
  ChainDataFrame("CmdStan Summary", df)
  
end   # end of read_samples
