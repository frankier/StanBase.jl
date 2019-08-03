using MCMCChains, CSV

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

  fname = joinpath(m.tmpdir, "$(m.name)_summary.csv")
  
  df = CSV.read(fname, delim=",", comment="#")
  
  cnames = lowercase.(convert.(String, String.(names(df))))
  cnames[1] = "parameters"
  cnames[4] = "std"
  cnames[8] = "ess"
  names!(df, Symbol.(cnames))
  df[!, :parameters] = Symbol.(df[!, :parameters])
  
  ChainDataFrame("CmdStan Summary", df)
  
end   # end of read_samples
