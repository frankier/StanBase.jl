using StanBase

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

stanmodel = HelpModel( "help", stan_prog;
  method = StanBase.Help(help=:sample),
  tmpdir = joinpath(@__DIR__, "/tmp"))

res = stan_help(stanmodel;n_chains=1)

if !isnothing(res)

run(`cat $(res[1][2])`)

end
