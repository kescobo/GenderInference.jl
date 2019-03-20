function update_genders!(d::Dict, name, year, gender, n)
    if !haskey(d, name)
        d[name] = Dict{Int, Dict}()
    end
    if !haskey(d[name], year)
        d[name][year] = Dict{Symbol, Int}()
    end
    haskey(d[name][year], gender) && error("duplicate $gender entry for $name $year")

    d[name][year][gender] = n
end


function generate_names()
    datfolder = datadep"US Census - names"
    genders = Dict{String, Dict}()

    for y in filter(f-> occursin(r"^yob\d{4}", f), readdir(datfolder))
        year = match(r"yob(\d{4})\.txt", y).captures[1] |> x -> parse(Int, x)

        for line in eachline(joinpath(datfolder, y))
            (name, gender, n) = split(line, ',')

            gender in ("M", "F") || error("Gender $gender not recognized")
            gender == "F" ? gender = :female : gender = :male

            n = parse(Int, n)

            update_genders!(genders, name, year, gender, n)
        end

    end
    return genders
end
