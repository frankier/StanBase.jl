struct Help <: CmdStanMethods
  help::Symbol
end
Help(;help=:help) = Help(:help)
