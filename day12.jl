using Base: product
using DataStructures: DefaultDict
CI = CartesianIndex

farm = permutedims(hcat(split.(readlines("inputs/day12.txt"), "")...), (2, 1))
n = size(farm, 1)

function in_bounds(x, n)
    (1 <= x[1] <= n) && (1 <= x[2] <= n)
end

function neighbors(coordinate, n)
    return filter(x -> in_bounds(x, n), [coordinate + x for x in [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]])
end


# region-walk algorithm:
# first, identify how many regions there are
# we'll conventionally say a region's "starting point" is the leftmost, and secondarily topmost, point in the region

# nope, first shot at this didn't work because these are "non-convex" regions
# i.e. it's possible to have a high-up right hand region that won't discover its starting point
# just by going left.

# new attempt: just start doing a region walk from the top left, then restart from the earliest index that wasn't visited during that walk.

function day12_1()
    index_stack = [CI(1,1)]
    visited_map = zeros(Int, n, n) # 0 means unvisited, 1, 2, ... n are the region numbers
    current_region_number = 1
    areas = DefaultDict{Int64,Int64}(0)
    perimeters = DefaultDict{Int64,Int64}(0)
    while length(index_stack) > 0
        visit_index = popfirst!(index_stack)
        visited_map[visit_index] = current_region_number
        areas[current_region_number] += 1
        current_neighbors = neighbors(visit_index, n)
        contiguous = filter(x -> farm[x] == farm[visit_index], current_neighbors)
        perimeters[current_region_number] += 4 - length(contiguous)
        append!(index_stack, filter(x -> !(x in index_stack) && visited_map[x] == 0, contiguous))
        if length(index_stack) == 0 && any(visited_map .== 0)
            current_region_number += 1
            push!(index_stack, findfirst(x -> x == 0, visited_map))
        end
    end
    sum(areas[k] * perimeters[k] for k in 1:current_region_number)
end

@time day12_1()

# now that we have a contiguous region map, let's walk them to find the perimeters
# wait, we don't even need to walk them
# perimeter algorithm = sum(4 - the number of neighbors in the same region)
