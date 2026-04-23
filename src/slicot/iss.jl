# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct ISS <: Benchmark
    variant::String
end

@associate ISS("1R") "iss_n270m3q3"
@associate ISS("12A") "iss_n1412m3q3"

"""
    ISS(variant::String) <: Benchmark

Allowed variants: $(list_variants(ISS))

!!! compat "MORWiki v0.3.5"
    This data set requires MORWiki version 0.3.5 or later.
"""
ISS
