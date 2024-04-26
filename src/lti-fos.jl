# This file is part of MORWiki. License is MIT: https://spdx.org/licenses/MIT.html

"""
    FirstOrderSystem(; E=I, A, B, C, D=false*I)

Linear time-invariant first-order system (LTI-FOS).

    E ẋ(t) = A x(t) + B u(t)
      y(t) = C x(t) + D u(t)

If not specified, `E` is set to the identity and `D` to the zero map.
"""
Base.@kwdef struct FirstOrderSystem{Etype,Atype,Btype,Ctype,Dtype} <: StateSpaceRepresentation
    E::Etype = I
    A::Atype
    B::Btype
    C::Ctype
    D::Dtype = false * I
end

function Base.show(io::IO, fos::FirstOrderSystem)
    @unpack E, A, B, C, D = fos
    print(io, "FirstOrderSystem:")
    if E != I
        print(io, "\n  E: ", summary(E))
    end
    print(io, "\n  A: ", summary(A))
    print(io, "\n  B: ", summary(B))
    print(io, "\n  C: ", summary(C))
    if D != false * I
        print(io, "\n  D: ", summary(D))
    end
    nothing
end
