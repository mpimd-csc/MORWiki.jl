# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

abstract type TunableOpticalFilter <: Benchmark end
struct Filter2D <: TunableOpticalFilter end
struct Filter3D <: TunableOpticalFilter end

@associate Filter2D() "tunableOpticalFilter_n1668m1q5"
@associate Filter3D() "tunableOpticalFilter_n106437m1q5"

"""
    Filter2D() <: Benchmark

!!! compat "MORWiki v0.3.4"
    This data set requires MORWiki version 0.3.4 or later.
"""
Filter2D

"""
    Filter3D() <: Benchmark

!!! compat "MORWiki v0.3.4"
    This data set requires MORWiki version 0.3.4 or later.
"""
Filter3D
