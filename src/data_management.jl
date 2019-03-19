function generate_names()
    datfolder = datadep"US Census - names"
    name_dict = Dict()
    for y in filter(f-> occursin(r"^yob\d{4}", f), datfolder)
        table = CSV.File(joinpath(datfolder, y))
    end

end
