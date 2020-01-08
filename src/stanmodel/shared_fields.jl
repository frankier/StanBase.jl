macro shared_fields_stanmodels()
  return esc(:(
    name::AbstractString;              # Name of the Stan program
    model::AbstractString;             # Stan language model program
    n_chains::Vector{Int64};           # Number of chains
    seed::StanBase.RandomSeed;         # Seed section of cmd to run cmdstan
    init::StanBase.Init;               # Init section of cmd to run cmdstan
    output::StanBase.Output;           # Output section of cmd to run cmdstan
    tmpdir::AbstractString;            # Holds all below copied/created files
    output_base::AbstractString;       # Used for naming failes to be created
    exec_path::AbstractString;         # Path to the cmdstan excutable
    data_file::Vector{String};         # Array of data files input to cmdstan
    init_file::Vector{String};         # Array of init files input to cmdstan
    cmds::Vector{Cmd};                 # Array of cmds to be spawned/pipelined
    sample_file::Vector{String};       # Sample file array created by cmdstan
    log_file::Vector{String};          # Log file array created by cmdstan
    diagnostic_file::Vector{String};   # Diagnostic file array created by cmdstan
    summary::Bool;                     # Store cmdstan's summary as a .csv file
    printsummary::Bool;                # Print the summary
    cmdstan_home::AbstractString;      # Directory where cmdstan can be found
  ))
end
