register(DataDep(
    "US Census - names",
    """US Census data, 1880-2017.
        https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data""",
    "https://www.ssa.gov/oact/babynames/names.zip",
    post_fetch_method=file->run(`unzip $file`)
    ))

function _update_genders!(gender_dict::Dict, name, year, gender, n)
    if !haskey(gender_dict, name)
        gender_dict[name] = Dict{Int, Dict}()
    end
    if !haskey(gender_dict[name], year)
        gender_dict[name][year] = Dict{Symbol, Int}()
    end
    haskey(gender_dict[name][year], gender) && error("duplicate $gender entry for $name $year")

    gender_dict[name][year][gender] = n
end


function _generate_names_dict()
    datfolder = datadep"US Census - names"
    gender_dict = Dict{String, Dict}()

    for y in filter(f-> occursin(r"^yob\d{4}", f), readdir(datfolder))
        year = match(r"yob(\d{4})\.txt", y).captures[1] |> x -> parse(Int, x)

        for line in eachline(joinpath(datfolder, y))
            (name, gender, n) = split(line, ',')

            gender in ("M", "F") || error("Gender $gender not recognized")
            gender == "F" ? gender = :female : gender = :male

            n = parse(Int, n)

            _update_genders!(gender_dict, name, year, gender, n)
        end

    end
    return gender_dict
end

function _resolve_names!(gender_dict)
    for name in keys(gender_dict)
        for year in keys(gender_dict[name])
            if !haskey(gender_dict[name][year], :male)
                gender_dict[name][year][:male] = 0
            end
            if !haskey(gender_dict[name][year], :female)
                gender_dict[name][year][:female] = 0
            end
        end
    end

end

@info "Genderating name => gender dict, this might take a sec"

const NAMES = _generate_names_dict()
_resolve_names!(NAMES)
