# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct MicropyrosThruster <: Benchmark
    variant::Symbol

    function MicropyrosThruster(variant::Symbol; check::Bool = true)
        if check
            supported = keys(VARIANTS[MicropyrosThruster])
            check_variant("variant", variant, supported)
        end
        new(variant)
    end
end

@associate MicropyrosThruster(:T2DAL) "micropyrosThruster_n4257m1q7"
@associate MicropyrosThruster(:T2DAH) "micropyrosThruster_n11445m1q7"
@associate MicropyrosThruster(:T3DL) "micropyrosThruster_n20360m1q7"
@associate MicropyrosThruster(:T3DH) "micropyrosThruster_n79171m1q7"

"""
    MicropyrosThruster(variant::Symbol) <: Benchmark

Allowed variants: $(list_variants(MicropyrosThruster))

!!! compat "MORWiki v0.3.4"
    This data set requires MORWiki version 0.3.4 or later.
"""
MicropyrosThruster
