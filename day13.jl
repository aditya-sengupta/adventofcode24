using Convex
using GLPK

raw_input = readlines("inputs/day13.txt")
A_buttons = match.(r"Button A: X\+(\d+), Y\+(\d+)", raw_input[1:4:end])
B_buttons = match.(r"Button B: X\+(\d+), Y\+(\d+)", raw_input[2:4:end])
goals = match.(r"Prize: X=(\d+), Y=(\d+)", raw_input[3:4:end])

function solve(x, y, z1, z2)
    pushes = Variable(2, IntVar)
    constraints = [dot(pushes, x) == z1, dot(pushes, y) == z2]
    cost = [3, 1]
    p = minimize(dot(cost, pushes), constraints)
    solve!(p, GLPK.Optimizer; silent=true)
    try
        return Int(dot(cost, (evaluate(pushes))))
    catch e
        return 0
    end
end

begin
    t = 0
    for (a, b, g) in zip(A_buttons, B_buttons, goals)
        X1, Y1 = parse(Int, a[1]), parse(Int, a[2])
        X2, Y2 = parse(Int, b[1]), parse(Int, b[2])
        Z1, Z2 = parse(Int, g[1]), parse(Int, g[2])
        Z1 += 10000000000000
        Z2 += 10000000000000
        t += solve([X1, X2], [Y1, Y2], Z1, Z2)
    end
    t
end
