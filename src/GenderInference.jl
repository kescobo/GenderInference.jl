module GenderInference

export
    gendercount,
    percentfemale,
    percentmale,
    gender

using DataDeps
using Logging

include("data_management.jl")
include("inference.jl")


end # module Gender Inference
