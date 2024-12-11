input_str = readlines("inputs/day9_test.txt")[1]

storage_blocks = parse.(Int, split(input_str[1:2:end], ""))
space_blocks = parse.(Int, split(input_str[2:2:end], ""))

checksum = 0
n = 0
# while n < 