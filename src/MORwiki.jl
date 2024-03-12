# This file is part of MORwiki. License is MIT: https://spdx.org/licenses/MIT.html

module MORwiki

using DataDeps: DataDep, register
using unzip_jll: unzip

# Naming scheme: register_PREFIX()
# where PREFIX is the common benchmark ID prefix as specified on MOR Wiki.
#
# If part of a variant's suffix is common to all benchmark IDs, it may be omitted from PREFIX.
# For example, use boneModel instead of boneModelB.

function register_steelProfile()
    function post_fetch_method(file)
        run(`$(unzip()) -q $file`)
        rm(file)
    end

    for (dim, hash) in [
        (1357, "8e9d1bb6c382b134362e1df5614c5a165b2bac678b38933ca25ca137b54c43ad"),
        (5177, "710942c89ae2beac051c97fa782d9bf529b01e4aa2c9ddf44b6ba1022103920f"),
        (20_209, "cb6d3ab7d4a1e33779ad27665072115118f0e0603ab75ff5827ed551b3175619"),
        (79_841, "298f0b985007414625fbecf83a8650ead3760e79a23a66e8119e6f906f0ce49e"),
    ]
        zipfile = "SteelProfile-dim1e$(round(Int, log10(dim)))-rail_$dim.zip"
        datadep = DataDep(
            "steelProfile_n$(dim)m7q6",
            "A Semi-discretized Heat Transfer Problem for Optimal Cooling of Steel Profiles",
            "https://csc.mpi-magdeburg.mpg.de/mpcsc/MORWIKI/Oberwolfach/$zipfile",
            hash;
            post_fetch_method,
        )
        register(datadep)
    end
end

function __init__()
    register_steelProfile()
    nothing
end

end # module MORwiki
