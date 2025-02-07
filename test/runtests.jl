using Test
using CodeLoadingOrders
using UnicodePlots
using Aqua
using TOML;

@testset "CodeLoadingOrders" begin
    deps = collect(
        keys(TOML.parsefile(joinpath(pkgdir(CodeLoadingOrders), "Project.toml"))["deps"]),
    )

    deps = ["Aqua", "TOML", "UnicodePlots", "Test"]
    @show deps
    (; best_found_order, best_time, time_seconds) = explore_code_loading_order(
        deps;
        env = pkgdir(CodeLoadingOrders),
        n_permutations = 10,
    )
    time_seconds_vals = Float64.(collect(values(time_seconds)))
    println(UnicodePlots.histogram(time_seconds_vals, closed = :left))
end

@testset "Aqua" begin
    Aqua.test_all(CodeLoadingOrders)
end
