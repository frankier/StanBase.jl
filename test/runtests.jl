using StanBase
using Test

@testset "Bernoulli basic runs" begin
  
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

  struct DummyMethod  <: AbstractCmdStanMethod
    name::AbstractString
  end

  function DummyMethod(name="dummy_method") end
  
  tmpdir = joinpath(@__DIR__, "tmp")

  CmdStanDummyModel(name, prog, n_chains=[4]; kwargs...) =
    CmdStanModel(name, prog, DummyMethod("test"); kwargs...)

  stanmodel = CmdStanDummyModel("bernoulli_prog", stan_prog; tmpdir=tmpdir)

  @test stanmodel.method == DummyMethod("test")
  @test typeof(stanmodel) == CmdStanModel

end
