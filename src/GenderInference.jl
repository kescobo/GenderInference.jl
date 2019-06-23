__precompile__(false)

module GenderInference

export
    gendercount,
    proportionfemale,
    proportionmale,
    gender

using DataDeps
using BSON

include("data_registrations.jl")
include("data_management.jl")
include("inference.jl")

function __init__()
    datadep"US Census - names"
    nothing
end

end # module Gender Inference
