struct NameDataset
    firstyear::Int32
    lastyear::Int32
    namesdict::Dict

    NameDataset(fy, ly) = new(Int32(fy), Int32(ly), Dict())
end

firstyear(nds::NameDataset) = nds.firstyear
lastyear(nds::NameDataset) = nds.lastyear

_years(nds::NameDataset) = (firstyear(nds), lastyear(nds))



getindex(nds::NameDataset, key::AbstractString) = Base.getindex(nds.namesdict, lowercase(key))
haskey(nds::NameDataset, name::AbstractString) = Base.haskey(nds.namesdict, lowercase(name))

# check to prevent overwriting
function addname(nds::NameDataset, name::AbstractString)
    haskey(nds, name) && return true
    nds.namesdict[lowercase(name)] = (female=spzeros(Int32, nds.lastyear), male=spzeros(Int32, nds.lastyear))
end


function _update_genders!(nds::NameDataset, name, year, gender, n)
    firstyear, lastyear = _years(nds)
    firstyear <= year <= lastyear || throw(ArgumentError("This dataset only has years $firstyear to $lastyear"))
    name = lowercase(name)
    addname(nds, name)
    nds[name][gender][year] > 0 && error("duplicate $gender entry for $name $year")

    nds[name][gender][year] = n
end


struct RawDataSet{T} end

RawDataSet(s::String) = RawDataSet{Symbol(s)}()
RawDataSet(s::Symbol) = RawDataSet{s}()

parsedataset(datfolder, ::RawDataSet) = throw(ArgumentError("Unknown Dataset"))

function parsedataset(datfolder, ::RawDataSet{:USCensus})
    nds = NameDataset(1880, 2018)

    for y in filter(f-> occursin(r"^yob\d{4}", f), readdir(datfolder))
        year = match(r"yob(\d{4})\.txt", y).captures[1] |> x -> parse(Int32, x)

        for line in eachline(joinpath(datfolder, y))
            (name, gender, n) = split(line, ',')

            gender in ("M", "F") || error("Gender $gender not recognized")
            gender == "F" ? gender = :female : gender = :male

            n = parse(Int32, n)

            _update_genders!(nds, name, year, gender, n)
        end

    end
    return nds
end



const NAMES = parsedataset(datadep"US Census - names", RawDataSet("USCensus"))
