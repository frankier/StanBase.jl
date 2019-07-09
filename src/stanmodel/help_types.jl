struct Help
  help::Symbol
end
Help(;help=:help) = Help(:help)

stan_help = stan_sample
