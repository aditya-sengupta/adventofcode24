using ProgressMeter
using Memoization
using StatsBase: countmap

@memoize function rule(n)
    if n == 0
        return [1]
    end
    strn = string(n)
    length_strn = length(strn)
    if length_strn % 2 == 0
        return [parse(Int, strn[1:length_strn÷2]), parse(Int, strn[length_strn÷2+1:end])]
    end
    return [n * 2024]
end

function rule_iteration(stones)
    next_stones = DefaultDict{Int64,Int64}(0)
    for n in keys(stones)
        n_nexts = rule(n)
        for n_next in n_nexts
            next_stones[n_next] += stones[n]
        end
    end
    return next_stones
end

function day11(niter)
    stones = countmap(parse.(Int, split.(readlines("inputs/day11.txt"), " ")[1]))
    for _ in 1:niter
        stones = rule_iteration(stones)
    end

    sum(v for (k, v) in stones)
end

@time begin
    day11(25)
    day11(75)
end;