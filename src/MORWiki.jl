# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

module MORWiki

using LinearAlgebra: I
using Base.Threads: @spawn
using Compat: argmin
using DataDeps: DataDep, register, @datadep_str
using DelimitedFiles: readdlm
using DocStringExtensions: TYPEDEF
using InteractiveUtils: subtypes
using MatrixMarket: mmread
using SparseArrays: sparse, spzeros
using UnPack: @unpack
using ZipArchives: ZipReader, zip_openentry
using unzip_jll: unzip
using MAT: matopen
using Mmap: mmap
using Tar: Tar
using CodecZlib: GzipDecompressorStream

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

"""
    assemble(::Benchmark)::StateSpaceRepresentation

Return assembled system matrices.
"""
function assemble(benchmark::Benchmark)
    # Select datadep string:
    T = typeof(benchmark)
    if fieldcount(T) == 0
        dep = VARIANTS[T]::String
    elseif fieldcount(T) == 1
        key = getfield(benchmark, 1)
        dep = VARIANTS[T][key]::String
    else
        error("not yet implemented")
    end

    # Load MAT file:
    dir = @datadep_str dep
    fname = only(readdir(dir, join=true))
    mat = matopen(fname)

    # What version of MAT file is this?
    @debug "assemble($benchmark)" typeof(mat)

    # Load system matrices:
    E = "E" in keys(mat) ? read(mat, "E") : I
    A = read(mat, "A")
    B = read(mat, "B")
    C = read(mat, "C")
    D = "D" in keys(mat) ? read(mat, "D") : false * I
    FirstOrderSystem(; E, A, B, C, D)
end

"""
    instances([T])::Vector{Benchmark}

Return all (natively allowed) instances of type `T` where `T <: Benchmark`.
If `T` is not given, use [`Benchmark`](@ref).

```jldoctest
julia> using MORWiki: ConvectiveThermalFlow, instances

julia> instances(ConvectiveThermalFlow)
4-element Vector{MORWiki.Benchmark}:
 MORWiki.Chip(0.0)
 MORWiki.Chip(0.1)
 MORWiki.FlowMeter(0.0)
 MORWiki.FlowMeter(0.5)

```
"""
instances() = instances(Benchmark)

function instances(T::Type)
    benchmarks = Benchmark[]
    if isconcretetype(T)
        if (vs = variants(T)) == nothing
            push!(benchmarks, T())
        else
            for v in vs
                push!(benchmarks, T(v))
            end
        end
    else
        for S in subtypes(T)
            append!(benchmarks, instances(S))
        end
    end
    return benchmarks
end

function check_variant(description, variant, supported)
    v = argmin(v -> abs(v - variant), supported)
    v == variant || throw(ArgumentError("Unsupported $description $variant. Did you mean $v?"))
    nothing
end

function check_variant(description, variant::Union{String, Symbol}, supported)
    # Simply list all variants here,
    # since we don't have string similarity measures (yet).
    if !(variant in supported)
        sorted = sort(collect(supported))
        others = if length(sorted) <= 2
            join(sorted, " or ")
        else
            join(sorted, ", ", ", or ")
        end
        throw(ArgumentError("Unsupported $description $variant. Did you mean $others?"))
    end
    nothing
end

const VARIANTS = Dict()

macro associate(instance, depname)
    @assert instance.head == :call
    typename, args... = instance.args

    if length(args) == 0
        esc(:(VARIANTS[$typename] = $depname))
    elseif length(args) == 1
        key = only(args)
        esc(quote
            let
                K = typeof($key)
                variants = get!(VARIANTS, $typename, Dict{K,String}())
                variants[$key] = $depname
            end
        end)
    else
        error("not yet implemented")
    end
end

# Utility to embed allowed variants in docstrings:
list_variants(T::Type) = join(sort(collect(variants(T))), ", ")

# Utility to collect arguments needed to instantiate benchmarks:
variants(T::Type) = variants(VARIANTS[T])
variants(d::Dict) = keys(d)
variants(_::String) = nothing # no arguments passed to constructor

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
# Consider breaking above rules.
#
include("oberwolfach/ctf.jl")
include("oberwolfach/micropyrosThruster.jl")
include("oberwolfach/nonLinearHeatTransfer.jl")
include("oberwolfach/rclCircuitEquations.jl")
include("oberwolfach/steelProfile.jl")
include("oberwolfach/oberwolfach.jl")
include("misc/fenicsRail.jl")
include("slicot/iss.jl")
include("slicot/mna.jl")
include("slicot/penzlFOM.jl")
include("slicot/slicot.jl")

function __init__()
    # Register standardized benchmarks in bulk:
    register_morwiki_csv()

    # Register remaining benchmarks:
    register_ctf()
    register_fenicsRail()
    register_steelProfile()

    nothing
end

function register_morwiki_csv()
    # Load metadata from CSV:
    if (metadata = get(ENV, "MORWIKI_CSV", "")) != ""
        @info "Using $metadata"
    else
        metadata = joinpath(@__DIR__, "..", "morwiki.csv")
    end
    delim = only(get(ENV, "MORWIKI_CSV_DELIM", ","))
    data_cells, header_cells = readdlm(
        metadata, delim;
        comments = true,
        header = true,
    )

    # Perform rudimentary schema validation:
    ok = true
    expected_header = [
        "id",
        "morwiki_name",
        "morwiki_url",
        "data_url",
        "data_hash",
    ]
    n = length(expected_header)
    if length(header_cells) < n
        @warn "Not enough columns in MORWIKI_CSV; skipping datadep registration"
        ok = false
    elseif header_cells[1:n] != expected_header
        expected = join(expected_header, delim)
        got = join(header_cells[1:n], delim)
        @warn "Unexpected column names in MORWIKI_CSV; skipping datadep registration" expected got
        ok = false
    end

    ok || return

    @debug "Adding $(size(data_cells, 1)) benchmarks from MORWIKI_CSV"
    for row in eachrow(data_cells)
        id = string(row[1])
        morwiki_name = row[2]
        morwiki_url = row[3]
        data_url = string(row[4])
        data_hash = string(row[5])
        message = """
        Dataset: $morwiki_name
        Documentation: $morwiki_url
        """
        datadep = DataDep(id, message, data_url, data_hash)
        register(datadep)
    end
end

end # module MORWiki
