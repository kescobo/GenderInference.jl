function gendercount(name::AbstractString, year::Int)
    year in keys(NAMES[name]) || throw(KeyError("No $name born in $year"))

    f = NAMES[name][year][:female]
    m = NAMES[name][year][:male]
    return (female=f, male=m)
end

function gender(name::AbstractString, year::Int; threshold::AbstractFloat=0.8)
    0. ≤ threshold ≤ 1. || raise(ArgumentError("Threshold must be between 0 and 1"))
    (f, m) = gendercount(name, year)

    pf::AbstractFloat = f / (f+m)

    if pf > threshold
        return :female
    elseif pf < 1. - threshold
        return :male
    else
        return missing
    end
end

function gender(name::AbstractString)
end


function gender(name::AbstractString, years::AbstractArray{<:Int})
end

function gender(name::AbstractString, years::UnitRange)
end
