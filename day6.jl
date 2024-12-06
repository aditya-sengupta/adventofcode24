using DelimitedFiles
using ProgressMeter
using Base.Threads: @threads

maze_orig = permutedims(hcat(split.(readdlm("inputs/day6_test.txt"), "")...), (2, 1))
next_move = Dict("^" => ">", ">" => "v", "v" => "<", "<" => "^")
starting_position = (x -> [x[1], x[2]])(only(filter(x -> length(x) > 0, union(
        findall(maze_orig .== x)
        for x in ["^", ">", "<", "v"]
    )))[1])
starting_orientation = maze_orig[starting_position...]

function proposed_move(current_position, move_direction)
    proposed_position = copy(current_position)
    if move_direction == "^"
        proposed_position[1] -= 1
    elseif move_direction == ">"
        proposed_position[2] += 1
    elseif move_direction == "<"
        proposed_position[2] -= 1
    elseif move_direction == "v"
        proposed_position[1] += 1
    end
    return proposed_position
end

function maze_walk(maze, starting_position, starting_orientation)
    walked_maze = copy(maze_orig)
    current_position = copy(starting_position)
    walk_locations = []
    move_direction = starting_orientation
    move_directions = []
    while true
        proposed_position = current_position
        while !(walked_maze[proposed_position[1], proposed_position[2]] in [".", "X"])
            proposed_position = proposed_move(current_position, move_direction)
            if !(1 <= proposed_position[1] <= size(maze, 1)) || !(1 <= proposed_position[2] <= size(maze, 2))
                return walk_locations, move_directions, 0
            elseif maze[proposed_position[1], proposed_position[2]] == "#"
                move_direction = next_move[move_direction]
            end
        end
        check_infinite_loop = findall([all(x .== current_position) for x in walk_locations])
        @show current_position, proposed_position
        @show check_infinite_loop
        if length(check_infinite_loop) > 0
            if move_direction in move_directions[check_infinite_loop]
                return walk_locations, move_directions, 1
            end
        end
        walked_maze[current_position[1], current_position[2]] = "X"
        push!(walk_locations, current_position)
        push!(move_directions, move_direction)
        current_position = proposed_position
        walked_maze[current_position[1], current_position[2]] = move_direction
    end
end

maze_walk(maze_orig, [6, 5], "^")

function day6_1(maze_orig, starting_position, starting_orientation)
     return 1 + length(Set(maze_walk(maze_orig, starting_position, starting_orientation)[1]))
end

day6_1(maze_orig, starting_position, starting_orientation)

walk_locations, move_directions, infinite_loops = maze_walk(maze_orig, starting_position, starting_orientation)

for (w, d) in zip(walk_locations, move_directions)
    println(w, d)
    @assert maze_walk(maze_orig, w, d)[3] == 0
end