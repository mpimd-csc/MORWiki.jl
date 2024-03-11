# MOR Wiki

Download data sets from [MOR Wiki].
If a certain data set has not been added, yet, please open an issue.

## Installation

```
pkg> add MORWiki
```

## Getting Started

The data sets are available via [DataDeps.jl] using their [MOR Wiki] benchmark IDs.

```julia
using MORWiki, DataDeps

datadep"steelProfile_n1357m7q6"
```

[DataDeps.jl]: https://github.com/oxinabox/DataDeps.jl
[MOR Wiki]: http://modelreduction.org/
