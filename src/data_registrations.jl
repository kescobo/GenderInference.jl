
# This will be called by __init__
function init_us_census()
    register(DataDep(
        "US Census - names",
        """US Census data, 1880-2017.
            https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data""",
        "https://www.ssa.gov/oact/babynames/names.zip",
        post_fetch_method=unpack
        ))
end
