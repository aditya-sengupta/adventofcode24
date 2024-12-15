using Base: prod
using Plots
using StatsBase: std

raw_input = readlines("inputs/day14.txt")
grid_size = [101, 103]
midpoint = grid_size .÷2

states = [parse.(Int, collect(match(r"p=(\-?\d+),(\-?\d+) v=(\-?\d+),(\-?\d+)", line))) for line in raw_input]

states_mat = hcat(states...)'

function day14_1()
    per_quadrant = [0, 0, 0, 0]
    final_states = []
    for state in states
        pos = state[1:2]
        vel = state[3:4]
        pos += 100 * vel
        pos = pos .% grid_size
        negative_indices = findall(pos .< 0)
        pos[negative_indices] .+= grid_size[negative_indices]
        push!(final_states, pos)
        is_left = pos[1] < midpoint[1]
        is_right = pos[1] > midpoint[1]
        is_up = pos[2] < midpoint[2]
        is_down = pos[2] > midpoint[2]
        for (i, (b1, b2)) in enumerate(zip([is_left, is_left, is_right, is_right], [is_up, is_down, is_up, is_down]))
            per_quadrant[i] += b1 * b2
        end
    end
    prod(per_quadrant)
end

function iterate!(states_mat)
    states_mat[:,1:2] .+= states_mat[:,3:4]
    states_mat[:,1] .%= grid_size[1]
    states_mat[:,2] .%= grid_size[2]
    negative_indices_1 = findall(states_mat[:,1] .< 0)
    negative_indices_2 = findall(states_mat[:,2] .< 0)
    states_mat[negative_indices_1,1] .+= grid_size[1]
    states_mat[negative_indices_2,2] .+= grid_size[1]
end

begin
    states_mat = hcat(states...)'
    N = 8168
    var_vals = zeros(N)
    for i in 1:N
        iterate!(states_mat)
        var_vals[i] = std(states_mat[:,1])^2 + std(states_mat[:,2])^2
    end
    argmin(var_vals)
end

begin
    grid = zeros(Bool, grid_size[2], grid_size[1])
    for s in eachrow(states_mat)
        grid[s[2]+1, s[1]+1] = true
    end
    heatmap(grid)
end