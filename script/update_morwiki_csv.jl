import Pkg
Pkg.activate(@__DIR__)

using CSV: CSV
using DataFrames
using Downloads: download

## Download "next gen" metadata
base_url = "https://modelreduction.org/morb-data"
upstream = joinpath(@__DIR__, "upstream.csv")
download("$base_url/examples.csv", upstream)

df_raw = CSV.read(upstream, DataFrame)
subset!(
    df_raw,
    :systemClass => ByRow(==("LTI-FOS")),
    :category => ByRow(==("oberwolfach")),
    :id => ByRow(!startswith("steelProfile")), # curated locally
    :id => ByRow(!startswith("ctf")), # curated locally
)
# TODO(data-breaking): Drop the distinction for SteelProfile, Chip, and FlowMeter.
df = select(
    df_raw,
    :id,
    :MORWikiPageName => :morwiki_name,
    :MORWikiLink => :morwiki_url,
    [:category, :id] => ByRow((c, i) -> "$base_url/$c/$i.mat") => :data_url,
    :sourceFilehash => :data_hash,
)

## Write metadata
sort!(df, :id)
out = joinpath(@__DIR__, "..", "morwiki.csv")
CSV.write(out, df)
