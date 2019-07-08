# This is a template for definining the real models we're after for cmdstan, e.g.
# sample_stan_model(...) and variational_sample_model(...)

using StanBase
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

# DummyMethod holds the structs for the specific Stan method
# to generate the cmdline, e.g. Sample(), Optimize(), ...
struct DummyStanMethod  <: CmdStanMethods
  name::AbstractString
end
DummyStanMethod()=DummyStanMethod("dummy_method")

# Add the new method to a basic CmdStanModel
struct DummyStanModel <: CmdStanModels
  method::CmdStanMethods
  csm::CmdStanModel
end
DummyStanModel(;method=DummyStanMethod(), csm=CmdStanModel(name, prog))=
  DummyStanModel(method, csm)

# Handle display of new DummyStanModel
function dummy_stan_model_show(io::IO, m::DummyStanModel, compact::Bool)
  println("  method =                  $(m.method)")
  show(m.csm)
end

show(io::IO, m::DummyStanModel) = dummy_stan_model_show(io, m, false)

# Primary constructor
function dummy_stan_model(name, prog; kwargs...)
  DummyStanModel(
    :method in keys(kwargs) ? kwargs[:method] : DummyStanMethod(),
    CmdStanModel(name, prog; kwargs...))
end
