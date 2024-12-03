using BenchmarkTools

raw_input = readlines("inputs/day3.txt")

re = r"mul\((\d+),(\d+)\)"
re_do = r"do\(\)"
re_dont = r"don't\(\)"

function day3(part1=true)
    total = 0
    enabled = true
    for row in raw_input
        idx = 1
        while true
            m = match(re, row, idx)
            if isnothing(m) # end when there's no more muls
                break
            end
            m_do = match(re_do, row, idx)
            m_dont = match(re_dont, row, idx)
            all_matches = [m, m_do, m_dont]
            offsets = [isnothing(m) ? Inf : m.offset for m in all_matches]
            next_match_idx = argmin(offsets)
            if next_match_idx == 1 && enabled
                d1, d2 = parse(Int, m.captures[1]), parse(Int, m.captures[2])
                total += d1 * d2
            elseif next_match_idx == 2
                enabled = true
            elseif next_match_idx == 3 && !part1
                enabled = false # change this to 'true' for part 1
            end
            idx = Int(offsets[next_match_idx]) + length(all_matches[next_match_idx].match)
        end
    end
    total
end

@btime day3(true)
@btime day3(false)