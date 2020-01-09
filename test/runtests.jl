using StanBase
using Test

stan_prog = "
data { 
  int<lower=1> N; 
  int<lower=0,upper=1> y[N];
  real empty[0];
} 
parameters {
  real<lower=0,upper=1> theta;
} 
model {
  theta ~ beta(1,1);
  y ~ bernoulli(theta);
}
";


#@testset "Basic HelpModel" begin
  
  debug = true

  sm = HelpModel( "help", stan_prog)
  debug && println("\nModel compilation completed.")
  debug && run(`ls -lia $(sm.tmpdir)`)

  if debug

    println("\nRun command:\n")
    res = run(`$(sm.output_base) sample help`)
    println(res)

    println("\nPipeline version:\n")
    res = run(pipeline(`$(sm.output_base) sample help`, 
      stdout="$(sm.output_base)_log_2.log", append=false))
    println()
    run(`ls -lia $(sm.tmpdir)`)
    println()
    
  end

    debug && println("\nstan_sample:\n")
    return_codes = stan_sample(sm; n_chains=1, debug=debug)
    debug && println("Sampling completed.\n")

  if return_codes[1]
    debug && run(`ls -lia $(sm.tmpdir)`)
    println()
    run(`cat $(sm.log_file[1])`)
    @test sm.method == StanBase.Help(:sample)
    @test StanBase.get_n_chains(sm) == 1
  end

#end
