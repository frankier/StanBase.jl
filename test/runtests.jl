using StanBase
using Test

import Base.show

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

struct DummyMethod  <: CmdStanMethods
  name::AbstractString
end

function DummyMethod(name="dummy_method") end

tmpdir = joinpath(@__DIR__, "tmp")

struct DummyModel
  method::CmdStanMethods
  csm::CmdStanModel
end

function dummymodel_show(io::IO, m::DummyModel, compact::Bool)
  println("  method =                  $(m.method)")
  show(m.csm)
end

show(io::IO, m::DummyModel) = dummymodel_show(io, m, false)

function dummymodel(name, prog; kwargs...)
 DummyModel(
   DummyMethod("test"),
   CmdStanModel(name, prog; kwargs...))
 end

@testset "Bernoulli basic runs" begin
  
  global stanmodel = dummymodel("bernoulli_prog", stan_prog; tmpdir=tmpdir)
  show(stanmodel)

  @test stanmodel.method == DummyMethod("test")
  @test typeof(stanmodel.csm) == CmdStanModel

end
