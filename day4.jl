using LinearAlgebra: diag

wordgrid = permutedims(string.(hcat(split.(readlines("inputs/day4.txt"), "")...)), [2, 1])
k = size(wordgrid, 1)

function day4_1()
    n = k - 1
    wordgrid_flip = reverse(wordgrid, dims=1)

    xmas_count = 0
    rows = string.(eachcol(wordgrid)...) # semantics of array parsing are weird so don't worry about rows vs cols
    cols = string.(eachrow(wordgrid)...)
    diagonals = [string.(diag(wordgrid, k)...) for k in -n:n]
    reverse_diagonals = [string.(diag(wordgrid_flip, k)...) for k in -n:n]

    for search_substring in [rows, cols, diagonals, reverse_diagonals]
        xmas_count += sum(length(findall("XMAS", x)) for x in search_substring)
        xmas_count += sum(length(findall("XMAS", x)) for x in reverse.(search_substring))
    end
    xmas_count
end

function day4_2()
    mas_count = 0
    for idx in findall(x -> x == "A", wordgrid[2:end-1,2:end-1])
        left_diag = sort([wordgrid[idx[1],idx[2]], wordgrid[idx[1]+2,idx[2]+2]])
        right_diag = sort([wordgrid[idx[1]+2,idx[2]], wordgrid[idx[1],idx[2]+2]])
        if left_diag == right_diag == ["M", "S"]
            mas_count += 1
        end
    end
    mas_count
end

@time day4_1()
@time day4_2()