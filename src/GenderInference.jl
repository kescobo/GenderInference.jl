__precompile__(false)

module GenderInference

export
    gendercount,
    percentfemale,
    percentmale,
    gender

using DataDeps
using BSON
using Logging


function __init__()
    register(DataDep(
        "US Census - names",
        """US Census data, 1880-2017.
            https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data""",
        "https://www.ssa.gov/oact/babynames/names.zip",
        post_fetch_method=file->run(`unzip $file`)
        ))
    datadep"US Census - names"
    nothing
end

include("data_management.jl")
include("inference.jl")


end # module Gender Inference
