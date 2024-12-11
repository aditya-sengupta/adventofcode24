using Base: product
CI = CartesianIndex

hike_map = parse.(Int, hcat(split.(readlines("inputs/day10_test.txt"), "")...))'
n = size(hike_map, 1)

function in_bounds(x)
    (1 <= x[1] <= n) && (1 <= x[2] <= n)
end

function neighbors(coordinate)
    return filter(in_bounds, [coordinate + x for x in [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]])
end

lookup_by_number = Dict(x => [] for x in 0:9) # yeah yeah dynamic resizing, whatever
for idx in product(1:n, 1:n)
    push!(lookup_by_number[hike_map[idx...]], idx)
end

trailheads = collect(lookup_by_number[0]) # just so there's a consistent order
reachable_map = zeros(Bool, n, n, length(trailheads))
# reachable_map[i, j, k] = if [i, j] is reachable from trailhead [k]

for (k, t) in enumerate(trailheads)
    reachable_map[t..., k] = true
end

for level in 0:8
    for idx in lookup_by_number[level]
        # look up every position that's at "level"
        # get each of its neighbors that's at level - 1
        useful_neighbors = filter(x -> Tuple(x) in lookup_by_number[level+1], neighbors(CI(idx)))
        for u in useful_neighbors
            reachable_map[u, :] = reachable_map[u, :] .| reachable_map[idx..., :]
        end
    end
end

score = 0
for summit in lookup_by_number[9]
    score += sum(reachable_map[summit..., :])
end
score