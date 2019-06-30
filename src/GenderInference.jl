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

# function __init__()
#     include("data_registrations.jl")
# end

end # module Gender Inference
