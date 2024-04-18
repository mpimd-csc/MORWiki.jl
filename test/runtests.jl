# This file is part of MORwiki. License is MIT: https://spdx.org/licenses/MIT.html

using MORwiki: MORwiki, SteelProfile, assemble
using LinearAlgebra, SparseArrays, Test, UnPack

@testset "MORwiki.jl" begin
    @test_throws ArgumentError SteelProfile(300)
    @test_throws ArgumentError("Unsupported dimension 300. Did you mean 371?") SteelProfile(300)
    @test_throws ArgumentError("Unsupported dimension 1000. Did you mean 1357?") SteelProfile(1000)

    rail = SteelProfile(371)
    @test rail isa MORwiki.Benchmark

    fos = assemble(rail)
    @test fos isa MORwiki.FirstOrderSystem

    @unpack E, A, B, C, D = fos
    @test E isa SparseMatrixCSC
    @test A isa SparseMatrixCSC
    @test B isa SparseMatrixCSC
    @test C isa SparseMatrixCSC
    @test D isa UniformScaling
    @test size(E) == (371, 371)
    @test size(A) == (371, 371)
    @test size(B) == (371, 7)
    @test size(C) == (6, 371)
    @test D === false * I
    @test issymmetric(E)
    @test issymmetric(A)
end
