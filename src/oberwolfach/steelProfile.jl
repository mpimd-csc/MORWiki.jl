# This file is part of MORwiki. License is MIT: https://spdx.org/licenses/MIT.html

const DIM_HASH_steelProfile = [
    (371, "ae4da7dba1b218f5f6f74c4e9194aa759ff8140f5a5d74247ee59e2447fd6093"),
    (1357, "8e9d1bb6c382b134362e1df5614c5a165b2bac678b38933ca25ca137b54c43ad"),
    (5177, "710942c89ae2beac051c97fa782d9bf529b01e4aa2c9ddf44b6ba1022103920f"),
    (20_209, "cb6d3ab7d4a1e33779ad27665072115118f0e0603ab75ff5827ed551b3175619"),
    (79_841, "298f0b985007414625fbecf83a8650ead3760e79a23a66e8119e6f906f0ce49e"),
]

const DOC_steelProfile = """
A Semi-discretized Heat Transfer Problem for Optimal Cooling of Steel Profiles
"""

function register_steelProfile()
    function post_fetch_method(file)
        run(`$(unzip()) -q $file`)
        rm(file)
    end

    for (dim, hash) in DIM_HASH_steelProfile
        zipfile = "SteelProfile-dim1e$(round(Int, log10(dim)))-rail_$dim.zip"
        datadep = DataDep(
            "steelProfile_n$(dim)m7q6",
            DOC_steelProfile,
            "https://csc.mpi-magdeburg.mpg.de/mpcsc/MORWIKI/Oberwolfach/$zipfile",
            hash;
            post_fetch_method,
        )
        register(datadep)
    end
end

"""
    SteelProfile(dim::Int) <: Benchmark

$(DOC_steelProfile)

Allowed dimensions: 371, 1357, 5177, 20209, 79841

!!! compat "MORwiki 0.1.2"
    Dimension 371 requires MORwiki version 0.1.2 or later.
"""
struct SteelProfile <: Benchmark
    dim::Int

    function SteelProfile(dim::Int)
        check_dimension(dim, DIM_HASH_steelProfile)
        new(dim)
    end
end

function assemble(rail::SteelProfile)
    dim = rail.dim
    dep = "steelProfile_n$(dim)m7q6"
    dir = @datadep_str dep

    E = mmread(joinpath(dir, "rail_$(dim)_c60.E"))
    A = mmread(joinpath(dir, "rail_$(dim)_c60.A"))
    B = mmread(joinpath(dir, "rail_$(dim)_c60.B"))
    C = mmread(joinpath(dir, "rail_$(dim)_c60.C"))

    FirstOrderSystem(; E, A, B, C)
end
