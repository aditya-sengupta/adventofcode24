input_str = readlines("inputs/day9.txt")[1]

function day9_1()

    storage_blocks = parse.(Int, split(input_str[1:2:end], ""))
    space_blocks = parse.(Int, split(input_str[2:2:end], ""))

    space_indices = []
    storage_indices = []
    idx = 0
    storage = -ones(Int, sum(storage_blocks) + sum(space_blocks))
    for (i, (store, space)) in enumerate(zip(storage_blocks, space_blocks))
        push!(storage_indices, idx+1:idx+store)
        storage[idx+1:idx+store] .= i - 1
        idx += store
        push!(space_indices, idx+1:idx+space)
        idx += space
    end
    push!(storage_indices, idx+1:idx+storage_blocks[end])
    storage[idx+1:idx+storage_blocks[end]] .= length(space_blocks)

    checksum, start_index, end_index = 0, 1, length(storage)
    while start_index <= end_index
        if storage[start_index] > -1
            checksum += storage[start_index] * (start_index - 1)
            start_index += 1
        else
            if storage[end_index] > -1
                storage[[start_index, end_index]] = storage[[end_index, start_index]]
            end
            end_index -= 1
        end
    end
    checksum
end

@time day9_1()