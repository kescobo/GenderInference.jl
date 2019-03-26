using GenderInference
using Test

@testset "Gender Inference" begin
    @test typeof(GenderInference.NAMES) <: AbstractDict

    @test gender("Kevin") == :male
    @test gender("rachel") == :female
    @test gender("foo") === missing
    @test gender("casey") == :male
    @test gender("casey", threshold=0.8) === missing

    @test typeof(gendercount("stefan")) <: NamedTuple{(:female,:male), Tuple{Int,Int}}
    @test typeof(gendercount("bar")) <: NamedTuple{(:female,:male), Tuple{Int,Int}}

    @test typeof(percentfemale("Viral")) <: AbstractFloat
    @test typeof(percentmale("Jane")) <: AbstractFloat
    @test percentfemale("Baz") === missing
    @test percentmale("Far") === missing

    @test gendercount("Julia", 1850:1900) === (female=missing, male=missing)
end
