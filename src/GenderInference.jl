module GenderInference

export
    gendercount,
    percentfemale,
    percentmale,
    gender

using DataDeps
using BSON
using Logging

include("data_management.jl")
include("inference.jl")


end # module Gender Inference
