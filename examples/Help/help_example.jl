using StanBase

ProjDir = @__DIR__

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

sm = HelpModel( "help", stan_prog;
  method = StanBase.Help(help=:sample),
  tmpdir = joinpath(ProjDir, "tmp"))

res = stan_help(sm; n_chains=1)

if !isnothing(res)
	run(`cat $(res[1][2])`)
end
