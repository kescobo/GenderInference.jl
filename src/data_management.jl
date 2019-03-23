register(DataDep(
    "US Census - names",
    """US Census data, 1880-2017.
        https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data""",
    "https://www.ssa.gov/oact/babynames/names.zip",
    post_fetch_method=file->run(`unzip $file`)
    ))

function _update_genders!(gender_dict::Dict, name, year, gender, n)
    name = lowercase(name)
    if !haskey(gender_dict, name)
        gender_dict[name] = Dict{Int, Dict}()
    end
    if !haskey(gender_dict[name], year)
        gender_dict[name][year] = Dict{Symbol, Int}()
    end
    haskey(gender_dict[name][year], gender) && error("duplicate $gender entry for $name $year")

    gender_dict[name][year][gender] = n
end


function _generate_names_dict(datfolder)
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

function _get_names_dict(datfolder)
    if isfile(joinpath(datfolder, "names.bson"))
        return BSON.load(joinpath(datfolder, "names.bson"))
    else
        @info "Genderating name to gender dict, this might take a sec (but should only happen once)"
        names = _generate_names_dict(datfolder)
        _resolve_names!(names)
        bson(joinpath(datfolder, "names.bson"), names)
        return names
    end
end

const NAMES = _get_names_dict(datadep"US Census - names")
