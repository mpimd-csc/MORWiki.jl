# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

const DIM_HASH_fenicsRail = [
    (371, "cdbce8c1791b8cdfe943d5e029e02159b345b48f90dec9530cdad2cdfe2113e1"),
    (1357, "50085f12a82359146e3bcbb4f185f64544147d5cecf1828a4dac6475108c8849"),
    (5177, "25d0ea7fbda9989607c970b1910f04b7f0a33221052c76b9b6fab42ff8e9b92d"),
    (20_209, "cb5360f281ff928f4beb41f8c8816e3d218b51db8f0ceabe6774d3f2a1cf57b7"),
    (79_841, "daf7abcbe27b5b9c04c0379f8910cb0e47d5a4cbc5f31f64239c78f8b496aeb6"),
    (317_377, "289f07c66dd34c70beaeebacec0fa0a243e3d1b884d850adf150c5dd4a6fbb92"),
    (1_265_537, "586b5d2ec07706754403ff121a06c53f0a4111ca0c63adf6224e79bb7329c972"),
]

function register_fenicsRail()
    for (dim, hash) in DIM_HASH_fenicsRail
        zipfile = "fenics_rail_$dim.zip"
        datadep = DataDep(
            "fenicsRail_n$(dim)m7q6",
            DOC_steelProfile,
            "https://zenodo.org/records/5113560/files/$zipfile",
            hash;
        )
        register(datadep)
    end
end

"""
    FenicsRail(dim::Int) <: Benchmark

$(DOC_steelProfile)

Allowed dimensions: 371, 1357, 5177, 20209, 79841, 317377, 1265537
"""
struct FenicsRail <: Benchmark
    dim::Int

    function FenicsRail(dim::Int)
        check_dimension(dim, DIM_HASH_fenicsRail)
        new(dim)
    end
end

function assemble(rail::FenicsRail)
    dim = rail.dim
    dep = "fenicsRail_n$(dim)m7q6"
    dir = @datadep_str dep
    zipfile = joinpath(dir, "fenics_rail_$dim.zip")

    archive = ZipReader(mmap(open(zipfile; read=true)))
    zip_mmread(file) = zip_openentry(mmread, archive, file)
    local E, A, B
    @sync begin
        @spawn E = zip_mmread("ODE_$(dim)_M.mtx")
        @spawn begin
            M = @spawn zip_mmread("ODE_$(dim)_M_GAMMA.mtx")
            A = zip_mmread("ODE_$(dim)_S.mtx")
            A = -(A + fetch(M))
        end
        @spawn begin
            B = zip_mmread("ODE_$(dim)_B.mtx")
            B = sparse(B)
        end
    end

    C = spzeros(eltype(B), 6, dim)
    C[1, [4, 22, 60]] .= [-1, -1, 3]
    C[2, [2, 3, 63]] .= [-1, -1, 2]
    C[3, [43, 51]] .= [-1, 1]
    C[4, [47, 55]] .= [-1, 1]
    C[5, [9, 16, 92]] .= [-1, -1, 2]
    C[6, [10, 15, 34, 83]] .= [-1, -1, -1, 3]

    FirstOrderSystem(; E, A, B, C)
end
