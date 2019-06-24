__precompile__(false)

module GenderInference

export
    gendercount,
    proportionfemale,
    proportionmale,
    gender

using DataDeps
using BSON
using SparseArrays

import Base: getindex, haskey

include("data_registrations.jl")
include("data_management.jl")
include("inference.jl")

end # module Gender Inference
