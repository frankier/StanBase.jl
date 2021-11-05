using StanBase
using Test

@testset "Basic HelpModel" begin
    
  @test CMDSTAN_HOME == get_cmdstan_home()

end