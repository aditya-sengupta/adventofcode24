using DelimitedFiles
using BenchmarkTools

raw_input = readlines("inputs/day2.txt")

function is_safe(row)
    if issorted(row) || issorted(reverse(row))
        adif = abs.(diff(row))
        if 1 <= maximum(adif) <= 3 && minimum(adif) > 0
            return true
        end
    end
    return false
end

function is_safe_damp(row)
    any(is_safe.(vcat(row[begin:i-1], row[i+1:end]) for i in 1:length(row)))
end

function is_safe_damp_opt(row)
    if is_safe(row)
        return true
    end
    for i in 1:length(row)
        if is_safe(vcat(row[begin:i-1], row[i+1:end]))
            return true
        end
    end
    return false
end

@time inp = [parse.(Int64, x) for x in split.(raw_input)]
@time sum(is_safe, inp)
@time sum(is_safe_damp_opt, inp)