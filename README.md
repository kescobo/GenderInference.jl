# Gender Inference

[![Build Status](https://travis-ci.com/kescobo/GenderInference.jl.svg?branch=master)](https://travis-ci.com/kescobo/GenderInference.jl) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

A package to infer a person's gender based on their first name,
with inspiration from the [Gender R package](https://www.r-project.org/nosvn/pandoc/gender.html).
For now, the data is limited to US names,
but hopefully that will change.

Please note: this package only deals with gender binaries.
For a critique and discussion about why this might not be a good idea,
[see here](https://ironholds.org/names-gender/).

See also [NameToGender.jl](https://github.com/JuliaText/NameToGender.jl)

## Datasets

The raw data set used in this package are available here:

- [Social Security Administration's baby names by year](http://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data)


### Not yet integrated

- [Mark Kantrowitz's name corpus](http://www.cs.cmu.edu/afs/cs/project/ai-repository/ai/areas/nlp/corpora/names/0.html)
- [IPUMS Census data](https://usa.ipums.org/)

## Usage

### Basic Usage

The first time you load the package,
it will download and process the data into a julia `Dict`.
This can take some time, but should only need to be done once
thanks to [`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl).

```julia
julia> using GenderInference
[ Info: Precompiling GenderInference [fce5760c-2382-526d-a3fa-df178b5473bd]
[ Info: Generating name to gender dict, this might take a bit (but should only happen once)
```

At present, this package has access to US data between 1880 and 2017
from the Social Security Administration.
You can ask for the counts of females and males with these names throughout this time,
or for a specific year, range of years, or vector of years.

```julia
julia> gendercount("kevin") # if you don't specify year(s), it will look at all records
(female = 5322, male = 1166731)

julia> gendercount("Stefan", 1976)
(female = 0, male = 208)

julia> gendercount("Jeff", 1950:1970)
(female = 190, male = 89892)

julia> gendercount("Viral", [1981, 1987, 1988])
(female = 0, male = 21)
```

You can also get the proportion of records that are male or female.

```julia
julia> proportionfemale("Jane")
0.9969477072813601

julia> proportionmale("Lyndon", 1980:2017)
0.9356575237118687
```

Or, if you just want to know if a name is more likely to be male or female:

```julia
julia> gender("Sebastian")
:male
```

By default, this function will return the majority gender.
In other words, even if only 51% is a specific gender, that will be returned.
But you can also set a threshold that has to be met.

```julia
julia> gender("Chris")
:male

julia> gender("Chris", threshold=0.90)
missing
```

### Data Availability

If you ask for a year that is unavailable, most functions will return `missing`

```julia
julia> proportionfemale("Kristoffer", 2019)
missing

julia> gender("simon", 1850)
missing
```

If there are no entries for a name, but the year is between 1880 and 2017,
`gendercount` will give zeros,
but the `proportion{gender}` functions will be missing.

```julia
julia> proportionfemale("kevin", 1900)
missing

julia> gendercount("kevin", 1900)
(female = 0, male = 0)
```
