"""

# Method `update_model_file`

Update Stan language model file if necessary 

### Method
```julia
StanSample.update_model_file(
  file::String, 
  str::String
)
```
### Required arguments
```julia
* `file::AbstractString`                : File for Stan model
* `str::AbstractString`                 : Stan model string
```

"""
function update_model_file(file::AbstractString, str::AbstractString)
  
  str2 = ""
  if isfile(file)
    resfile = open(file, "r")
    str2 = read(resfile, String)
    str2 = parse_and_interpolate(str2)
    str != str2 && rm(file)
  end
  if str != str2
    println("\nFile $(file) will be updated.\n")
    strmout = open(file, "w")
    write(strmout, str)
    close(strmout)
  end
  
end

function parse_and_interpolate(model::AbstractString)
  #model = open(f->read(f, String), model)
  newmodel = ""
  lines = split(model, "\n")
  for l in lines
    ls = strip(l)
    replace_strings = findall("#include", ls)
    if length(replace_strings) == 1
      for r in replace_strings
        ls = split(strip(ls[r[end]+1:end]), " ")[1]
        func = open(f -> read(f, String), strip(ls))
        newmodel *= "   "*func*"\n"
      end
    else
      if length(replace_strings) > 1
        error("Inproper #includes")
      else
        newmodel *= l*"\n"
      end
    end
  end
  newmodel
end
