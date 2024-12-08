using DelimitedFiles
using ProgressMeter
using Base.Threads: @threads

maze = permutedims(hcat(split.(readdlm("inputs/day6.txt"), "")...), (2, 1))
next_move = Dict("^" => ">", ">" => "v", "v" => "<", "<" => "^")
starting_position = (x -> [x[1], x[2]])(only(filter(x -> length(x) > 0, union(
        findall(maze .== x)
        for x in ["^", ">", "<", "v"]
    )))[1])
starting_orientation = maze[starting_position...]
maze[starting_position...] = "."

function proposal(state)
    next = copy(state)
    move_direction = state[3]
    if move_direction == "^"
        next[1] -= 1
    elseif move_direction == ">"
        next[2] += 1
    elseif move_direction == "<"
        next[2] -= 1
    elseif move_direction == "v"
        next[1] += 1
    end
    return next
end

function advance!(state, extra_obstacle=[0,0])
    while true
        proposed_state = proposal(state)
        if off_grid(proposed_state) || (maze[proposed_state[1], proposed_state[2]] != "#" && !all(proposed_state[1:2] .== extra_obstacle))
            state[:] = proposed_state
            return
        end
        state[3] = next_move[state[3]]
    end
end

function off_grid(state)
    return !(1 <= state[1] <= size(maze, 1)) || !(1 <= state[2] <= size(maze, 2))
end

seen_states = Tuple[]
current_state = [starting_position[1], starting_position[2], starting_orientation]
while !off_grid(current_state) && !(Tuple(current_state) in seen_states)
    push!(seen_states, Tuple(current_state))
    advance!(current_state)
end
seen_states
length(Set([[x[1], x[2]] for x in seen_states])) # part 1

successful_obstacle_locations = Set()
@showprogress @threads for i in 1:(length(seen_states)-1)
    # start iteration from each point along the unobstructed path
    # place an obstacle at the one just after
    state = seen_states[i]
    extra_obstacle_state = seen_states[i+1]
    current_state = [starting_position[1], starting_position[2], starting_orientation]
    seen_states_new = Tuple[]
    while !off_grid(current_state) && !(Tuple(current_state) in seen_states_new)
        push!(seen_states_new, Tuple(current_state))
        advance!(current_state, [extra_obstacle_state[1], extra_obstacle_state[2]])
    end
    if !(off_grid(current_state))
        push!(successful_obstacle_locations, Tuple(extra_obstacle_state[1:2]))
    end
end