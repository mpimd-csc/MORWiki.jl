# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

module MORWiki

using LinearAlgebra: I
using Base.Threads: @spawn
using Compat: argmin
using DataDeps: DataDep, register, @datadep_str
using DocStringExtensions: TYPEDEF
using MatrixMarket: mmread
using SparseArrays: sparse, spzeros
using UnPack: @unpack
using ZipArchives: ZipReader, zip_openentry
using unzip_jll: unzip
using Mmap: mmap
using Tar: Tar
using CodecZlib: GzipDecompressorStream

"""
    assemble(::Benchmark)::StateSpaceRepresentation

Return assembled system matrices.
"""
function assemble end

"""
$(TYPEDEF)

Lazy representation of a MOR Wiki benchmark.
Check out `subtypes(MORWiki.Benchmark)` for all available benchmarks.

See also: [`assemble`](@ref)
"""
abstract type Benchmark end

"""
$(TYPEDEF)

Collection of system matrices in state-space representation.

Available classes of systems:

* [`FirstOrderSystem`](@ref): linear time-invariant first-order system (LTI-FOS)

See also: [`assemble`](@ref)
"""
abstract type StateSpaceRepresentation end
include("lti-fos.jl")

function check_variant(description, variant, supported)
    v = argmin(v -> abs(v - variant), supported)
    v == variant || throw(ArgumentError("Unsupported $description $variant. Did you mean $v?"))
    nothing
end

# Let PREFIX denote the common benchmark ID prefix as specified on MOR Wiki.
# If part of a variant's suffix is common to all benchmark IDs, it may be omitted from PREFIX.
# For example, use boneModel instead of boneModelB.
#
# Create one file per benchmark, which defines the following methods:
#
# * Define function `register_PREFIX` which registers all DataDeps.jl dependencies,
#   and add this function to `__init__`.
# * Define `struct PREFIX <: Benchmark`, which lazily represents all variants of the benchmark.
#   Use the capitalized PREFIX to conform to the typical Julia naming scheme!
#   For example, use `struct BoneModel` instead of `struct boneModel`.
# * Define method `assemble(::PREFIX)` which loads/assembles the actual system matrices.
#   Return an appropriate sub-type of `StateSpaceRepresentation`.
#
include("oberwolfach/ctf.jl")
include("oberwolfach/steelProfile.jl")
include("misc/fenicsRail.jl")

function __init__()
    register_ctf()
    register_fenicsRail()
    register_steelProfile()
    nothing
end

end # module MORWiki
