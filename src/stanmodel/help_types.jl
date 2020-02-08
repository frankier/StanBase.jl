"""

Help composite type as used to construct the cmdline.

$(SIGNATURES)

# Extended help

Primarily used for testing of StanBase. `Help()` defaults to `Help(:sample)`.

Example: `Help(:optimize)`
"""
struct Help
  help::Symbol
end
Help() = Help(:sample)
