# MOR Wiki

Download data sets from [MOR Wiki].
If a certain data set has not been added, yet, please open an issue.

## Installation

```
pkg> add MORwiki
```

## Getting Started

The data sets are available via [DataDeps.jl] using their [MOR Wiki] benchmark IDs.

```julia
using MORwiki, DataDeps

datadep"steelProfile_n1357m7q6"
```

## License

The MORwiki package is licensed under [MIT](https://spdx.org/licenses/MIT.html), see `LICENSE`.
The data sets available from [MOR Wiki] have their own licenses.

[DataDeps.jl]: https://github.com/oxinabox/DataDeps.jl
[MOR Wiki]: http://modelreduction.org/
