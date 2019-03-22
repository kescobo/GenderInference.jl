function _getname(name)
    name = lowercase(name)
    if !in(name, keys(NAMES))
        @debug "$name is not a name I recognize" maxlog = 1
        return Dict{String, Dict}()
    end
    return NAMES[name]
end


function gendercount(name::AbstractString, year::Int)
    if year < 1880 || year > 2017
        @debug "Database only has years from 1880-2017" maxlog = 1
        return (missing, missing)
    end

    namedict = _getname(name)
    if !in(year, keys(namedict))
        @debug "No $name born in $year" maxlog = 1
        return (female=0, male=0)
    end

    f = namedict[year][:female]
    m = namedict[year][:male]
    return (female=f, male=m)
end

function gendercount(name::AbstractString, years::Union{Vector{T}, AbstractRange{T}}) where T <: Int
    f = 0
    m = 0

    for year in years
        c = gendercount(name, year)
        f += c[:female]
        m += c[:male]
    end
    return (female=f, male=m)
end

function gendercount(name::AbstractString)
    namedict = _getname(name)

    f = sum(skipmissing(namedict[year][:female] for year in keys(namedict)))
    m = sum(skipmissing(namedict[year][:male] for year in keys(namedict)))
    return (f, m)
end

function percentfemale(name, years=1880:2017)
    (f, m) = gendercount(name, years)
    return f / (f + m)
end

percentmale(name, years=1880:2017) = 1. - percentfemale(name, years)

function gender(name::AbstractString, year; threshold::AbstractFloat=0.8)
    0.5 ≤ threshold ≤ 1. || raise(ArgumentError("Threshold must be between 0.5 and 1"))
    (f, m) = gendercount(name, year)

    pf = percentfemale(name, year)

    if pf > threshold
        return :female
    elseif pf < 1. - threshold
        return :male
    else
        return missing
    end
end

gender(name::AbstractString; threshold::AbstractFloat=0.8) = gender(name, 1880:2017, threshold=threshold)
