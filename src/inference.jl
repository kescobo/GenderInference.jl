function gendercount(nds::NameDataset, name::AbstractString, years::Union{T, Vector{T}, AbstractRange{T}}) where T <: Integer
    if any(y-> firstyear(nds) > y || y > lastyear(nds), years)
        @debug "Database only has years from $(nds.firstyear)-$(nds.lastyear)" maxlog = 1
        return (female=missing, male=missing)
    elseif !haskey(nds, name)
        @debug "Database doesn't have name $name"
        return (female=0, male=0)
    else
        return (
            female = sum(nds[name][:female][years]),
            male   = sum(nds[name][:male][years])
            )
    end
end

gendercount(name::AbstractString, years::Union{T, Vector{T}, AbstractRange{T}}) where T <: Integer = gendercount(USCENSUS, name, years)
gendercount(nds::NameDataset, name::AbstractString) = gendercount(nds, name, firstyear(nds):lastyear(nds))
gendercount(name::AbstractString) = gendercount(USCENSUS, name)

function proportionfemale(name, years=1880:2018)
    (f, m) = gendercount(name, years)
    total = f+m
    (ismissing(total) || total == 0) && return missing
    return f / total
end

proportionmale(name, years=1880:2018) = 1. - proportionfemale(name, years)

function gender(name::AbstractString, year; threshold::AbstractFloat=0.5)
    0.5 ≤ threshold ≤ 1. || raise(ArgumentError("Threshold must be between 0.5 and 1"))
    pf = proportionfemale(name, year)

    ismissing(pf) && return missing

    if pf > threshold
        return :female
    elseif pf < 1. - threshold
        return :male
    else
        return missing
    end
end

gender(name::AbstractString; threshold::AbstractFloat=0.5) = gender(name, 1880:2017, threshold=threshold)
