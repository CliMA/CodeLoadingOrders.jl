# CodeLoadingOrders.jl

A package for exploring code loading orders, to find an order that results in
fast code loading times.

This was first experimentally used in ClimaAtmos as follows:

```julia
using CodeLoadingOrders
using UnicodePlots
using TOML;

deps = collect(keys(TOML.parsefile(".buildkite/Project.toml")["deps"]))

(; best_found_order, best_time, time_seconds) =
	explore_code_loading_order(deps; env = ".buildkite/", n_permutations = 3)

time_seconds_vals = Float64.(collect(values(time_seconds)))
println(UnicodePlots.histogram(time_seconds_vals, closed=:left))
```
