# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct NonlinearHeatTransfer <: Benchmark
    variant::Symbol

    function NonlinearHeatTransfer(variant::Symbol; check::Bool = true)
        if check
            supported = keys(VARIANTS[NonlinearHeatTransfer])
            check_variant("variant", variant, supported)
        end
        new(variant)
    end
end

@associate NonlinearHeatTransfer(:linear) "linearHeatTransfer_n15m2q2"

"""
    NonlinearHeatTransfer(variant::Symbol) <: Benchmark

Allowed variants: $(list_variants(NonlinearHeatTransfer))

!!! compat "MORWiki v0.3.4"
    This data set requires MORWiki version 0.3.4 or later.
"""
NonlinearHeatTransfer
