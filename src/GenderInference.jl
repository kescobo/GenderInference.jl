module GenderInference

export
    gendercount,
    proportionfemale,
    proportionmale,
    gender

using DataDeps
using BSON
using SparseArrays
using Logging

import Base: getindex, haskey

include("data_registrations.jl")
include("data_management.jl")
include("inference.jl")

function __init__()
    init_us_census()

    # Define global constant
    @eval const NAMES = parsedataset(datadep"US Census - names", RawDataSet("USCensus"))
end

end # module Gender Inference
