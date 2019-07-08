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

include("dummy_test.jl")

@testset "Bernoulli basic runs" begin
  
  # Just to prevent unnecessary recompilations of  stan_prog
  tmpdir = joinpath(@__DIR__, "tmp")

  stanmodel = dummy_stan_model("stan_prog", stan_prog; tmpdir=tmpdir)
  show(stanmodel)

  @test stanmodel.method == DummyStanMethod("dummy_method")
  @test typeof(stanmodel.csm) == CmdStanModel

  stanmodel = dummy_stan_model("stan_prog", stan_prog;
    method=DummyStanMethod("method2"))
  show(stanmodel)

  @test stanmodel.method == DummyStanMethod("method2")
  @test typeof(stanmodel.csm) == CmdStanModel

end
