using DelimitedFiles
using BenchmarkTools

inp = [parse.(Int64, x) for x in split.(readlines("inputs/day2.txt"))]

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

@btime sum(is_safe, inp)
@btime sum(is_safe_damp, inp)
