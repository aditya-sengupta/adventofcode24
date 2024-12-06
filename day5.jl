using BenchmarkTools

input_text = readlines("inputs/day5.txt")

function day5(input_text)
    sequencing_rules = filter(x -> occursin("|", x), input_text)
    ruleset = Dict()
    for x in sequencing_rules
        b, a = parse(Int, x[1:2]), parse(Int, x[4:5])
        if !(b in keys(ruleset))
            ruleset[b] = []
        end
        push!(ruleset[b], a)
    end
    updates = split.(filter(x -> occursin(",", x), input_text), ",")
    updates = [parse.(Int, x) for x in updates]
    must_come_before(x, y) = y in ruleset[x]
    is_valid(update) = issorted(update, lt=must_come_before)
    return (sum(update[length(update)÷2 + 1] for update in filter(is_valid, updates))), (sum(sort(update, lt=must_come_before)[length(update)÷2 + 1] for update in filter(!is_valid, updates)))
end

@btime day5(input_text)