module CodeLoadingOrders

export explore_code_loading_order
import Random

"""
	(; best_found_order, best_time, time_seconds) = explore_code_loading_order(
		deps::Vector{String};
		env::String,
		n_permutations::Int = 10
	)

Try loading dependencies `deps` in `n_permutations` permutations of orders,
and return the results.
"""
function explore_code_loading_order(
    deps::Vector{String};
    env::String,
    n_permutations::Int = 10,
)
    perm = collect(1:length(deps))
    time_seconds = Dict()
    println("Attempting $n_permutations permutations of code loading for deps $deps.")
    combo = deepcopy(deps)
    for iter = 1:n_permutations
        permute!(combo, perm)
        buff = IOBuffer()
        arg_list = join(combo, ", ")
        run(
            pipeline(
                `$(Base.julia_cmd()) --project=$(env) -e """print(@elapsed using $arg_list)"""`,
                stdout = buff,
            ),
        )
        s = String(take!(buff))
        time_seconds[combo] = parse(Float64, s)
        println("Order $arg_list results: $(time_seconds[combo])")
        if iter ≠ 1 # run first order twice, in case of warmup
        	Random.shuffle!(perm)
        end
    end
    best_time = minimum(values(time_seconds))
    K = collect(keys(time_seconds))
    i_best_found_order = findfirst(k -> time_seconds[k] == best_time, K)
    best_found_order = isnothing(i_best_found_order) ? :none_found : K[i_best_found_order]
    return (; best_found_order, best_time, time_seconds)
end

end # module CodeLoadingOrders
