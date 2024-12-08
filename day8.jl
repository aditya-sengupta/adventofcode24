grid = hcat(split.(readlines("inputs/day8.txt"), "")...)
n = size(grid, 1)

node_types = filter(x -> x != ".", unique(grid))

function in_bounds(x)
    (1 <= x[1] <= n) && (1 <= x[2] <= n)
end

function day8_1()
    antinode_locations = Set()
    for n in node_types
        grid_locations = findall(grid .== n)
        for idx1 in eachindex(grid_locations)
            for idx2 in idx1+1:length(grid_locations)
                push!(antinode_locations, 2 * grid_locations[idx1] - grid_locations[idx2])
                push!(antinode_locations, 2 * grid_locations[idx2] - grid_locations[idx1])
            end
        end
    end
    filter!(in_bounds, antinode_locations)
    length(antinode_locations)
end

function day8_2()
    antinode_locations = Set()
    for n in node_types
        grid_locations = findall(grid .== n)
        for idx1 in eachindex(grid_locations)
            for idx2 in idx1+1:length(grid_locations)
                diff_vector = grid_locations[idx1] - grid_locations[idx2]
                curr_location = grid_locations[idx1]
                while in_bounds(curr_location)
                    push!(antinode_locations, curr_location)
                    curr_location += diff_vector
                end
                curr_location = grid_locations[idx2]
                while in_bounds(curr_location)
                    push!(antinode_locations, curr_location)
                    curr_location -= diff_vector
                end
            end
        end
    end
    length(antinode_locations)
end

@time day8_1()
@time day8_2()