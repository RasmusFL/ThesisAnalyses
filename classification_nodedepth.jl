# all testing related to the section mlpre

include("../JuliaExtendableTrees/JuliaExtendableTrees.jl")

Random.seed!(2024)

# effect of nodedepth on the wine dataset
#------------------------------------------------------------------------------------

wine = CSV.read("wine.csv", DataFrame)
y = wine[:, :quality]
X = Matrix(wine[:, Not(:quality)])
oob_errors = Array{Float64}(undef, 29)
train_errors = Array{Float64}(undef, 29)

@time begin
    for b in 1:29
        wine_forest = grow_forest(X, y, "Classification", L_Entropy; max_depth = b + 1, min_node_size = 10, sfrac = 0.7, swr = false)
        oob_errors[b] = error_Classification(wine_forest, X, y, true)
        train_errors[b] = error_Classification(wine_forest, X, y)
        println(b)

        # clear memory before fitting a new forest
        wine_forest = nothing
    end
end

CSV.write("wine_nodedepth_Entropy.csv", Tables.table(hcat(1:29, train_errors, oob_errors)), writeheader = true)