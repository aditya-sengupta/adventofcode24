input_text = readlines("inputs/day5.txt")
sequencing_rules = filter(x -> occursin("|", x), input_text)
befores = [parse(Int, x[1:2]) for x in sequencing_rules]
afters = [parse(Int, x[4:5]) for x in sequencing_rules]
updates = filter(x -> occursin(",", x), input_text)
updates = [parse.(Int, split(x, ",")) for x in updates]
must_come_before(x, y) = y in afters[findall(befores .== x)]
is_valid(update) = issorted(update, lt=must_come_before)
day5_1() = sum(update[length(update)÷2 + 1] for update in filter(is_valid, updates))
day5_2() = sum(sort(update, lt=must_come_before)[length(update)÷2 + 1] for update in filter(!is_valid, updates))

day5_1()
day5_2()