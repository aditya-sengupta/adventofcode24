using Base: product
CI = CartesianIndex

function in_bounds(x, n)
    (1 <= x[1] <= n) && (1 <= x[2] <= n)
end

function neighbors(coordinate, n)
    return filter(x -> in_bounds(x, n), [coordinate + x for x in [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]])
end

function day10()
    hike_map = parse.(Int, hcat(split.(readlines("inputs/day10.txt"), "")...))'
    n = size(hike_map, 1)
    lookup_by_number = Dict(x => Set() for x in 0:9) # yeah yeah dynamic resizing, whatever
    for idx in product(1:n, 1:n)
        push!(lookup_by_number[hike_map[idx...]], idx)
    end

    reachable_map = zeros(Bool, n, n, length(lookup_by_number[0]))
    numpaths_map = zeros(Int, n, n, length(lookup_by_number[0]))
    # reachable_map[i, j, k] = if [i, j] is reachable from trailhead [k]

    for (k, t) in enumerate(lookup_by_number[0])
        reachable_map[t..., k] = true
        numpaths_map[t..., k] = 1
    end

    for level in 0:8
        for idx in lookup_by_number[level]
            # look up every position that's at "level"
            # get each of its neighbors that's at level - 1
            for u in filter(x -> Tuple(x) in lookup_by_number[level+1], neighbors(CI(idx), n))
                numpaths_map[u, :] .+= numpaths_map[idx..., :]
                reachable_map[u, :] .|= reachable_map[idx..., :]
            end
        end
    end

    score, rating = 0, 0
    for summit in lookup_by_number[9]
        score += sum(reachable_map[summit..., :])
        rating += sum(numpaths_map[summit..., :])
    end
    score, rating
end

@time day10()

