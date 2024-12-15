using Base: product
using DataStructures: DefaultDict
using Memoization
CI = CartesianIndex

farm = permutedims(hcat(split.(readlines("inputs/day12.txt"), "")...), (2, 1))
n = size(farm, 1)

function in_bounds(x, n)
    (1 <= x[1] <= n) && (1 <= x[2] <= n)
end

@memoize function neighbors(coordinate, n)
    return filter(x -> in_bounds(x, n), [coordinate + x for x in [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]])
end

function corners(coordinate)
    ncorners = 0
    x = farm[coordinate]
    for diagonal_offset in [CI(-1, -1), CI(-1, 1), CI(1, -1), CI(1, 1)]
        neighbor_x = coordinate + CI(diagonal_offset[1], 0)
        neighbor_y = coordinate + CI(0, diagonal_offset[2])
        x_in_region = in_bounds(neighbor_x, n) && farm[neighbor_x] == x
        y_in_region = in_bounds(neighbor_y, n) && farm[neighbor_y] == x
        if x_in_region && y_in_region
            ncorners += in_bounds(coordinate + diagonal_offset, n) && farm[coordinate + diagonal_offset] != x
        else
            ncorners += (!x_in_region && !y_in_region)
        end
    end

    ncorners
end

[corners(CI(x, y)) for (x, y) in product(1:4, 1:4)]

# region-walk algorithm:
# first, identify how many regions there are
# we'll conventionally say a region's "starting point" is the leftmost, and secondarily topmost, point in the region

# nope, first shot at this didn't work because these are "non-convex" regions
# i.e. it's possible to have a high-up right hand region that won't discover its starting point
# just by going left.

# new attempt: just start doing a region walk from the top left, then restart from the earliest index that wasn't visited during that walk.

function day12()
    index_stack = [CI(1,1)]
    visited_map = zeros(Bool, n, n) # 0 means unvisited, 1, 2, ... n are the region numbers
    price, discount_price = 0, 0
    curr_area, curr_perimeter, curr_sides = 0, 0, 0
    while true
        visit_index = popfirst!(index_stack)
        visited_map[visit_index] = true
        current_neighbors = neighbors(visit_index, n)
        contiguous = filter(x -> farm[x] == farm[visit_index], current_neighbors)
        curr_area += 1
        curr_perimeter += 4 - length(contiguous)
        curr_sides += corners(visit_index)
        append!(index_stack, filter(x -> !(x in index_stack) && !visited_map[x], contiguous))
        if all(visited_map)
            return price + curr_area * curr_perimeter, discount_price + curr_area * curr_sides
        elseif length(index_stack) == 0
            price += curr_area * curr_perimeter
            discount_price += curr_area * curr_sides
            curr_area, curr_perimeter, curr_sides = 0, 0, 0
            push!(index_stack, findfirst(x -> x == 0, visited_map))
        end
    end
end

# 860236 is too low

@time day12()

# now that we have a contiguous region map, let's walk them to find the perimeters
# wait, we don't even need to walk them
# perimeter algorithm = sum(4 - the number of neighbors in the same region)
