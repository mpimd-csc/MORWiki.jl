# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct RclCircuitEquations <: Benchmark
    variant::Symbol

    function RclCircuitEquations(variant::Symbol; check::Bool = true)
        if check
            supported = keys(VARIANTS[RclCircuitEquations])
            check_variant("variant", variant, supported)
        end
        new(variant)
    end
end

@associate RclCircuitEquations(:peec) "rclCircuitEquations_n306m2q2"
@associate RclCircuitEquations(:package) "rclCircuitEquations_n1841m16q16"

"""
    RclCircuitEquations(variant::Symbol) <: Benchmark

Allowed variants: $(list_variants(RclCircuitEquations))

!!! compat "MORWiki v0.3.4"
    This data set requires MORWiki version 0.3.4 or later.
"""
RclCircuitEquations
