# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

struct BuildingModel <: Benchmark end
struct CDPlayer <: Benchmark end
struct ClampedBeam <: Benchmark end
struct ConvectionReaction <: Benchmark end
struct EarthAtmosphere <: Benchmark end
struct HeatEquation <: Benchmark end
struct OrrSommerfeld <: Benchmark end
struct PeecModel <: Benchmark end
struct RandomSlicot <: Benchmark end
struct TransmissionLines <: Benchmark end

@associate BuildingModel() "buildingModel_n48m1q1"
@associate CDPlayer() "cdPlayer_n120m2q2"
@associate ClampedBeam() "clampedBeam_n348m1q1"
@associate ConvectionReaction() "convectionReaction_n84m1q1"
@associate EarthAtmosphere() "earthAtmosphere_n598m1q1"
@associate HeatEquation() "heatEquation_n200m1q1"
@associate OrrSommerfeld() "orrSommerfeld_n100m1q1"
@associate PeecModel() "peecModel_n480m1q1"
@associate RandomSlicot() "random_n200m1q1"
@associate TransmissionLines() "transmissionLines_n256m2q2"

for T in (:BuildingModel, :CDPlayer, :ClampedBeam, :ConvectionReaction,
          :EarthAtmosphere, :HeatEquation, :OrrSommerfeld, :PeecModel,
          :RandomSlicot, :TransmissionLines)

    docstring = """
        $T() :: Benchmark

    !!! compat "MORWiki v0.3.5"
        This data set requires MORWiki version 0.3.5 or later.
    """
    @eval @doc $docstring $T
end
