# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct MNA <: Benchmark
    variant::String

    function MNA(variant::String; check::Bool = true)
        if check
            supported = keys(VARIANTS[MNA])
            check_variant("variant", variant, supported)
        end
        new(variant)
    end
end

function MNA(dim::Int)
    supported = (578, 9223, 4863, 980, 10913)
    check_variant("dimension", dim, supported)
    i = findfirst(==(dim), supported)::Int
    return MNA(string(i))
end

@associate MNA("1") "mna_n578m9q9"
@associate MNA("2") "mna_n9223m18q18"
@associate MNA("3") "mna_n4863m22q22"
@associate MNA("4") "mna_n980m4q4"
@associate MNA("5") "mna_n10913m9q9"

"""
    MNA(variant::String)
    MNA(dim::Int)

Allowed variant strings: $(list_variants(MNA))

!!! compat "MORWiki v0.3.5"
    This data set requires MORWiki version 0.3.5 or later.
"""
MNA
