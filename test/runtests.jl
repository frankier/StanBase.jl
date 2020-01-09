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


@testset "Basic HelpModel" begin
  
  stanmodel = HelpModel( "help", stan_prog)
  println("\nModel compilation completed.")

  println("\nRun command:\n")
  res = run(`$(stanmodel.output_base) sample help`)
  println(res)

  println("\nPipeline version:\n")
  res = stan_sample(stanmodel; n_chains=1)
  println("Sampling completed.\n")

  if !isnothing(res[1])
    run(`cat $(res[1][2])`)
    @test stanmodel.method == StanBase.Help(:sample)
    @test StanBase.get_n_chains(stanmodel) == 1
  end

end
