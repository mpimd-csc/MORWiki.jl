# MOR Wiki

Download data sets from [MOR Wiki].
If a certain benchmark has not been added, yet, please open an issue.

## Installation

```
pkg> add MORwiki
```

## Getting Started

A ~~picture~~ code snippet is worth a thousand words:

```
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

## License

The MORwiki package is licensed under [MIT](https://spdx.org/licenses/MIT.html), see `LICENSE`.
The data sets available from [MOR Wiki] have their own licenses.

[DataDeps.jl]: https://github.com/oxinabox/DataDeps.jl
[MOR Wiki]: http://modelreduction.org/
