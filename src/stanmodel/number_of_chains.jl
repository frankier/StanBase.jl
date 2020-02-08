"""

Get the number of chains from a CmdStanModels object.

$(SIGNATURES)

# Extended help

Used to retrieve the current setting for number of chains as an `Int` number.
"""
function get_n_chains(model::T) where {T <: CmdStanModels}
  model.n_chains[1]
end

"""

Set the number of chains in a CmdStanModels object.

$(SIGNATURES)

# Extended help

Used to update the current setting for the number of chains ('n_chains[1]'). In the model
n_chains is defined as a Vector with a single element to allow this update when calling
`stan_sample()` and other methods.
"""
function set_n_chains(model::T, n_chains) where {T <: CmdStanModels}
  model.n_chains[1] = n_chains
end