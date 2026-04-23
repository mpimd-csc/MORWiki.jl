# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

"""
    PenzlFOM(p::Float64 = 100.0) <: Benchmark

Artificial system matrices of dimension 1006.

This data set does not have a corresponding `datadep""`;
no data will be ever be downloaded.

!!! compat "MORWiki v0.3.5"
    This data set requires MORWiki version 0.3.5 or later.
"""
@kwdef struct PenzlFOM <: Benchmark
    p::Float64 = 100.0
end

variants(::Type{PenzlFOM}) = nothing

function assemble(fom::PenzlFOM)
    dim = 1006
    nnz = dim + 6

    # Assemble matrix A via triplets:
    Is = Vector{Int}(undef, nnz)
    Js = Vector{Int}(undef, nnz)
    Vs = Vector{Float64}(undef, nnz)

    # Add blocks A1, A2, A3:
    row = 1
    i = 1
    for p in (fom.p, 200.0, 400.0)
        copyto!(Is, i, (row, row + 1, row, row + 1), 1)
        copyto!(Js, i, (row, row, row + 1, row + 1), 1)
        copyto!(Vs, i, (-1.0, -p, p, -1.0), 1)
        row += 2
        i += 4
    end

    # Add block A4:
    for j in 1:1000
        Is[i] = row
        Js[i] = row
        Vs[i] = -j
        row += 1
        i += 1
    end

    # Sanity check: the next row and i to be written to should be out-of-bounds.
    @assert row == dim + 1
    @assert i == nnz + 1

    # Convert to output format:
    A = sparse(Is, Js, Vs, dim, dim)
    B = Matrix{Float64}(undef, (dim, 1))
    B[1:6] .= 10
    B[7:end] .= 1
    C = B'

    return FirstOrderSystem(; A, B, C)
end
