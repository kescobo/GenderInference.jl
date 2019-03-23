# Gender Inference

A package to infer a person's gender based on their first name,
with inspiration from the [Gender R package][1].

## Datasets

The raw data set used in this package are available here:

- [Social Security Administration's baby names by year][2]


### Not yet integrated

- [Mark Kantrowitz's name corpus][3]
- [IPUMS Census data][4]

## Usage

The first time you load the package,
it will download and process the data into a julia `Dict`.
This can take some time, but should only need to be done once
thanks to [`DataDeps.jl`][5].

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
s

```




[1]: https://www.r-project.org/nosvn/pandoc/gender.html
[2]: http://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data
[3]: http://www.cs.cmu.edu/afs/cs/project/ai-repository/ai/areas/nlp/corpora/names/0.html
[4]: https://usa.ipums.org/
[5]: https://github.com/oxinabox/DataDeps.jl
