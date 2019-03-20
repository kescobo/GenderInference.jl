module GenderInference

using DataDeps
using Logging

function __init__()
    register(DataDep(
        "US Census - names",
        """US Census data, 1880-2017.
            https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data""",
        "https://www.ssa.gov/oact/babynames/names.zip",
        post_fetch_method=file->run(`unzip $file`)
    ))

    @info "Genderating name => gender dict, this might take a sec"
    const NAMES = _generate_names()
end

include("data_management.jl")

end # module Gender Inference
