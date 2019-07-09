"""

# cmdline 

Recursively parse the model to construct command line. 

### Method
```julia
cmdline(m)
```

### Required arguments
```julia
* `m::CmdStanSampleModel`                : CmdStanSampleModel
```

### Related help
```julia
?CmdStanSampleModel                      : Create a CmdStanSampleModel
```
"""
function cmdline(m, id)
  
  #=
  `./bernoulli3 help`,
  =#
  
  cmd = ``
  if isa(m, HelpModel)
    # Handle the model name field for unix and windows
    cmd = `$(m.exec_path)`

    # Sample() specific portion of the model
    cmd = `$cmd $(cmdline(getfield(m, :method), id))`
    
    #=
    # Common to all models
    cmd = `$cmd $(cmdline(getfield(m, :random), id))`
    
    # Init file required?
    if length(m.init_file) > 0 && isfile(m.init_file[id])
      cmd = `$cmd init=$(m.init_file[id])`
    else
      cmd = `$cmd init=$(m.init.bound)`
    end
    
    # Data file required?
    if length(m.data_file) > 0 && isfile(m.data_file[id])
      cmd = `$cmd id=$(id) data file=$(m.data_file[id])`
    end
    
    # Output options
    cmd = `$cmd output`
    if length(getfield(m, :output).file) > 0
      cmd = `$cmd file=$(string(getfield(m, :output).file))`
    end
    if length(m.diagnostic_file) > 0
      cmd = `$cmd diagnostic_file=$(string(getfield(m, :output).diagnostic_file))`
    end
    cmd = `$cmd refresh=$(string(getfield(m, :output).refresh))`
    =#
    
  else
    
    # The 'recursive' part
    cmd = `$cmd $(split(lowercase(string(typeof(m))), '.')[end])`
  end
  
  cmd
  
end

