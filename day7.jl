using ProgressMeter
using Base.Threads: @threads

input = split.(readlines("inputs/day7.txt"), ":")
totals = parse.(Int, [x[1] for x in input])
pieces = [parse.(Int, x[2:end]) for x in split.([x[2] for x in input], " ")]

function concatenate(n1, n2)
    return parse(Int, string(n1) * string(n2))
end

function reachable(total, total_so_far, numbers, concatenation_on=false)
    if length(numbers) == 0
        return total == total_so_far
    elseif total_so_far > total
        return false
    else
        return reachable(total, total_so_far + numbers[1], numbers[2:end], concatenation_on) || reachable(total, total_so_far * numbers[1], numbers[2:end], concatenation_on) || (concatenation_on && reachable(total, concatenate(total_so_far, numbers[1]), numbers[2:end], concatenation_on))
    end
end

function day7(concatenation_on)
    t0 = 0
    for (t, p) in zip(totals, pieces)
        t0 += t * reachable(t, 0, p, concatenation_on)
    end
    t0
end

@time day7(false)
@time day7(true)