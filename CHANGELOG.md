# v0.3.5

- Add SLICOT benchmark examples:
  `BuildingModel`, `CDPlayer`, `ClampedBeam`, `ConvectionReaction`,
  `EarthAtmosphere`, `HeatEquation`, `ISS`, `MNA`, `OrrSommerfeld`,
  `PenzlFOM`, `PeecModel`, `RandomSlicot`, `TransmissionLines`

# v0.3.4

- Add remaining LTI-FOS from Oberwolfach benchmark collection:
  `Filter2D`, `Filter3D`, `GasSensor`, `NonlinearHeatTransfer`,
  `MicropyrosThruster`, `PeekInductor`, `RclCircuitEquations`, and
  `SupersonicEngineInlet`
- Add `instances(T::Type)` to collect all benchmarks of type `T <: Benchmark`

# v0.3.3

- Fix `Chip` and `FlowMeter` when their type names would be qualified (https://github.com/mpimd-csc/MORWiki.jl/pull/6)

# v0.3.2

- Fix Julia 1.6 (https://github.com/mpimd-csc/MORWiki.jl/pull/5)

# v0.3.1

- Add `Chip` and `FlowMeter` (https://github.com/mpimd-csc/MORWiki.jl/pull/3)

# v0.3.0

- Breaking: Update ZipArchives to version 2 (https://github.com/mpimd-csc/MORWiki.jl/pull/2)

# v0.2.0

- Breaking: Rename package back to MORWiki.jl
- Breaking: Drop support for MatrixMarket.jl version 0.4
- Unpack data sets in-memory instead of unpacking to a `tempdir()`
