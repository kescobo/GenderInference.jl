using GenderInference
using Test

@testset "Gender Inference" begin
    @test typeof(GenderInference.NAMES) <: GenderInference.NameDataset

    @test gender("Kevin") == :male
    @test gender("rachel") == :female
    @test gender("foo") === missing
    @test gender("casey") == :male
    @test gender("casey", threshold=0.8) === missing

    @test typeof(gendercount("stefan")) <: NamedTuple{(:female,:male), Tuple{T,T}} where T <: Integer
    @test typeof(gendercount("bar")) <: NamedTuple{(:female,:male), Tuple{T,T}} where T <: Integer

    @test typeof(proportionfemale("Viral")) <: AbstractFloat
    @test typeof(proportionmale("Jane")) <: AbstractFloat
    @test proportionfemale("Foo") === missing
    @test proportionmale("Gadz") === missing

    @test gendercount("Julia", 1850:1900) === (female=missing, male=missing)
end
