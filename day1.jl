using DelimitedFiles
using StatsBase: countmap
using BenchmarkTools

raw_input = read("inputs/day1.txt")

# part 1
@btime begin
    inp = Int64.(readdlm(raw_input))
    sum(abs, sort(inp[:,1]) .- sort(inp[:,2]));
    # part 2
    cmap = countmap(inp[:,2])
    sum(x * get(cmap, x, 0) for x in inp[:,1])
end