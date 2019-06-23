using DataDeps

include(joinpath(@__DIR__,"..","src","data_registrations.jl"))
datadep"US Census - names"
