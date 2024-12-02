using DelimitedFiles
using StatsBase: countmap

inp = Int64.(readdlm("inputs/day1.txt"))
# part 1
sum(abs, sort(inp[:,1]) .- sort(inp[:,2]))

# part 2
cmap = countmap(inp[:,2])
sum(x * get(cmap, x, 0) for x in inp[:,1])