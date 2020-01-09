using StanBase

ProjDir = @__DIR__

bernoulli = "
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

sm = HelpModel( "bernoulli", bernoulli;
  method = StanBase.Help(:sample))

res = stan_help(sm; n_chains=1)

if !isnothing(res[1])
	run(`cat $(res[1][2])`)
end
