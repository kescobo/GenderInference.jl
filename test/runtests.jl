using GenderInference
using Test

@testset "Gender Inference" begin
    @test typeof(GenderInference.NAMES) <: AbstractDict

    @test gender("Kevin") == :male
    @test gender("rachel") == :female
    @test gender("foo") === missing

    @test typeof(gendercount("stefan")) <: NamedTuple{(:female,:male), Tuple{Int,Int}}
    @test typeof(gendercount("bar")) <: NamedTuple{(:female,:male), Tuple{Int,Int}}

    @test typeof(percentfemale("Viral")) <: AbstractFloat
    @test typeof(percentmale("Jane")) <: AbstractFloat
    @test percentfemale("Baz") === missing
    @test percentmale("Far") === missing
end
