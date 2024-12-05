# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

const VARIANTS_ctf = Dict(
    "Chip" => Dict(
        0.0 => (dep="ctfChipCoolingv0_n20082m1q5", suffix="chip_cooling_model_v0", hash="d1d6f43acb35ef72327b41fe4863f1bf1f7f60bdcf45a7108df932ec2e599c36"),
        0.1 => (dep="ctfChipCoolingv01_n20082m1q5", suffix="chip_cooling_model_v0.1", hash="8eaa7787ca8bc72a9cab50570033daa6acf7f8647d307b7d7f82bf7597bf72e5"),
    ),
    "FlowMeter" => Dict(
        0.0 => (dep="ctfFlowMeterv0_n9669m1q5", suffix="flow_meter_model_v0", hash="ee05a420869ea94632e72cc4382011b5cb40caa550545560bd4cdc2905dd89a5"),
        0.5 => (dep="ctfFlowMeterv05_n9669m1q5", suffix="flow_meter_model_v0.5", hash="8619dc97710fb16e6c757264d52f75400665785f7ce63fb034653c4b36587b4c"),
    ),
)

const DOC_ctf = """
Convective Thermal Flow Problems

http://modelreduction.org/index.php/Convective_Thermal_Flow
"""

function register_ctf()
    function post_fetch_method(tarball)
        # Unpack tarball:
        tar_gz = open(tarball)
        tar = GzipDecompressorStream(tar_gz)
        tmp = Tar.extract(tar)
        close(tar)

        # Move contents to dep directory:
        dir = only(readdir(tmp))
        src = joinpath(tmp, dir)
        dst = joinpath(dirname(tarball), dir)
        mv(src, dst)

        # Remove artifacts:
        rm(tarball)
        rm(tmp)
    end

    for variants in values(VARIANTS_ctf), (; dep, suffix, hash) in values(variants)
        file = "Convection-dim1e4-$suffix.tgz"
        datadep = DataDep(
            dep,
            DOC_ctf,
            "https://csc.mpi-magdeburg.mpg.de/mpcsc/MORWIKI/Oberwolfach/$file",
            hash;
            post_fetch_method,
        )
        register(datadep)
    end
end

abstract type ConvectiveThermalFlow <: Benchmark end

"""
    Chip(velocity::Float64) <: ConvectiveThermalFlow <: Benchmark

$(DOC_ctf)

Allowed velocities: 0, 0.1

!!! compat "MORWiki v0.3.1"
    This data set requires MORWiki version 0.3.1 or later.
"""
struct Chip <: ConvectiveThermalFlow
    velocity::Float64

    function Chip(velocity::Float64)
        supported = collect(keys(VARIANTS_ctf["Chip"]))
        check_variant("velocity", velocity, supported)
        new(velocity)
    end
end

"""
    FlowMeter(velocity::Float64) <: ConvectiveThermalFlow <: Benchmark

$(DOC_ctf)

Allowed velocities: 0, 0.5

!!! compat "MORWiki v0.3.1"
    This data set requires MORWiki version 0.3.1 or later.
"""
struct FlowMeter <: ConvectiveThermalFlow
    velocity::Float64

    function FlowMeter(velocity::Float64)
        supported = collect(keys(VARIANTS_ctf["FlowMeter"]))
        check_variant("velocity", velocity, supported)
        new(velocity)
    end
end

function assemble(ctf::ConvectiveThermalFlow)
    kind = string(typeof(ctf))
    @unpack dep, suffix = VARIANTS_ctf[kind][ctf.velocity]
    dir = @datadep_str dep

    E = mmread(joinpath(dir, suffix, "$suffix.E"))
    A = mmread(joinpath(dir, suffix, "$suffix.A"))
    B = mmread(joinpath(dir, suffix, "$suffix.B"))
    C = mmread(joinpath(dir, suffix, "$suffix.C"))

    FirstOrderSystem(; E, A, B, C)
end
