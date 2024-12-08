raw_input = readlines("inputs/day8.txt")

function in_bounds(x)
    (1 <= x[1] <= n) && (1 <= x[2] <= n)
end

function day8()
    grid = hcat(split.(raw_input, "")...)
    n = size(grid, 1)

    node_types = filter(x -> x != ".", unique(grid))
    antinode_locations_one = Set()
    antinode_locations_two = Set(findall(x -> x .!= ".", grid))
    for n in node_types
        grid_locations = findall(grid .== n)
        for idx1 in eachindex(grid_locations)
            for idx2 in idx1+1:length(grid_locations)
                diff_vector = grid_locations[idx1] - grid_locations[idx2]
                curr_location = 2 * grid_locations[idx1] - grid_locations[idx2]
                if in_bounds(curr_location) push!(antinode_locations_one, curr_location) end
                while in_bounds(curr_location)
                    push!(antinode_locations_two, curr_location)
                    curr_location += diff_vector
                end
                curr_location = 2 * grid_locations[idx2] - grid_locations[idx1]
                if in_bounds(curr_location) push!(antinode_locations_one, curr_location) end
                while in_bounds(curr_location)
                    push!(antinode_locations_two, curr_location)
                    curr_location -= diff_vector
                end
            end
        end
    end
    return length(antinode_locations_one), length(antinode_locations_two)
end

@time day8()