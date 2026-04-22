using MORWiki: FirstOrderSystem, assemble, instances

# Ensure download path is empty:
path = joinpath(@__DIR__, "data")
rm(path, recursive=true, force=true)
mkdir(path)
@info "Using $path"

ENV["DATADEPS_ALWAYS_ACCEPT"] = "1"
ENV["DATADEPS_LOAD_PATH"] = path
ENV["DATADEPS_NO_STANDARD_LOAD_PATH"] = "1"

## Gotta assemble them all
benchmarks = instances()
@info "Downloading $(length(benchmarks)) benchmark instances"

nfailed = 0
for benchmark in benchmarks
    try
        @info "$benchmark..."
        sys = assemble(benchmark)
        sys isa FirstOrderSystem || error("Assembly failed")
    catch
        global nfailed += 1
        @error "Something went wrong"
        # Continue testing next example; do not rethrow.
    end
end

exit(nfailed)
