using StanBase
using Test

@testset "Basic HelpModel" begin
    
  @test CMDSTAN_HOME == ENV[StanBase.CMDSTAN_HOME_VAR]

end