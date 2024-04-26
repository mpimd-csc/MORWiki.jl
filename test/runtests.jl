# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

using MORWiki: MORWiki, FenicsRail, SteelProfile, assemble
using LinearAlgebra, SparseArrays, Test, UnPack

@testset "MORWiki.jl" begin
    @test_throws ArgumentError SteelProfile(300)
    @test_throws ArgumentError("Unsupported dimension 300. Did you mean 371?") SteelProfile(300)
    @test_throws ArgumentError("Unsupported dimension 1000. Did you mean 1357?") SteelProfile(1000)

    rail = SteelProfile(371)
    @test rail isa MORWiki.Benchmark

    fos = assemble(rail)
    @test fos isa MORWiki.FirstOrderSystem
    @test startswith(string(fos), r"^FirstOrderSystem:\n  [EA]: ")

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

    @testset "Data consistency" begin
        @test typeof(fos) === typeof(assemble(FenicsRail(371)))
    end
end
