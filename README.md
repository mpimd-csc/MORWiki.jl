# MOR Wiki

Download data sets from [MOR Wiki].
If a certain benchmark has not been added, yet, please open an issue.

## Installation

```julia
import Pkg
Pkg.add("MORwiki")
```

## Getting Started

A ~~picture~~ code snippet is worth a thousand words:

```julia
using MORwiki: assemble, SteelProfile
using UnPack

@unpack E, A, B, C = assemble(SteelProfile(1357))
```

Should you get a benchmark's variant wrong,
the error message should guide you along:

```
julia> SteelProfile(1000)
ERROR: ArgumentError: Unsupported dimension 1000. Did you mean 1357?
[...]
```

For more granular control,
the data sets are available via [DataDeps.jl] using their [MOR Wiki] benchmark IDs:

```julia
using MORwiki, DataDeps

datadep"steelProfile_n1357m7q6"
```

## FAQ

- What triggers a download?

  A data set is downloaded when it is references via its `datadep""` identifier.
  This happens only when calling `assemble(...)`;
  creating `SteelProfile(1357)` or any other `MORwiki.Benchmark` does not download any data.
- Where are the data sets stored?

  This is handled purely by [DataDeps.jl].
  As of version 0.7.13, data is by default stored at
  `~/.julia/scratchspaces/124859b0-ceae-595e-8997-d05f6a7a8dfe/datadeps/`.
  Please refer to [DataDeps.jl]'s end-user documentation for further information.
- How are the data sets being stored?

  Currently, only `SteelProfile` is stored as plain MatrixMarket `.mtx` files.
  All other data sets are stored as a single `.zip` archive containing several `.mtx` files.

> [!WARNING]
> The following releases have been data-breaking:
> *none*
>
> Should you upgrade MORwiki.jl to (or skipping) one of the versions listed above,
> consult the `CHANGELOG` to see which data sets must be deleted and re-downloaded.
> Be assured that such changes will always be marked as a breaking release
> according to the [Pkg.jl documentation](https://pkgdocs.julialang.org/v1.6/compatibility/#compat-pre-1.0).
> Of course, not every API-breaking release is also data-breaking.

## Available Data Sets

The following list associates the subtypes of `MORwiki.Benchmark` to their [MOR Wiki] entries.
If a certain benchmark has not been added, yet, please open an issue.

- `SteelProfile`:
  [Oberwolfach Steel Profile](http://modelreduction.org/index.php/Steel_Profile) and
  [ALBERTA Rail 371](http://modelreduction.org/index.php/ALBERTA_Rail_371)
- `FenicsRail`: [FEniCS Rail](http://modelreduction.org/index.php/FEniCS_Rail)

## Acknowledgments

I would like to thank the code reviewers:

- Ashwin Nayak (https://github.com/ashwin-nayak)
- Jens Saak (https://github.com/drittelhacker)

## License

The MORwiki package is licensed under [MIT](https://spdx.org/licenses/MIT.html), see `LICENSE`.
The data sets available from [MOR Wiki] have their own licenses.

[DataDeps.jl]: https://docs.juliahub.com/General/DataDeps/0.7.13/z10-for-end-users/
[MOR Wiki]: http://modelreduction.org/
