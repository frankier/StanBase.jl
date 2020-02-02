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
  
  sm = HelpModel( "help", stan_prog)

  return_codes = stan_sample(sm; n_chains=4)

  if success(return_codes)
    println()
    @test sm.method == StanBase.Help(:sample)
    @test StanBase.get_n_chains(sm) == 4
  end

end
