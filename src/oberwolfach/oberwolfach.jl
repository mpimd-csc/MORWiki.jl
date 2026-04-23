# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct GasSensor <: Benchmark end
struct PeekInductor <: Benchmark end
struct SupersonicEngineInlet <: Benchmark end

abstract type TunableOpticalFilter <: Benchmark end
struct Filter2D <: TunableOpticalFilter end
struct Filter3D <: TunableOpticalFilter end

@associate GasSensor() "gasSensor_n66917m1q28"
@associate PeekInductor() "peekInductor_n1434m1q1"
@associate SupersonicEngineInlet() "supersonicEngineInlet_n11730m2q1"

@associate Filter2D() "tunableOpticalFilter_n1668m1q5"
@associate Filter3D() "tunableOpticalFilter_n106437m1q5"

for T in (:GasSensor, :PeekInductor, :SupersonicEngineInlet, :Filter2D, :Filter3D)
    docstring = """
        $T() :: Benchmark

    !!! compat "MORWiki v0.3.4"
        This data set requires MORWiki version 0.3.4 or later.
    """
    @eval @doc $docstring $T
end
