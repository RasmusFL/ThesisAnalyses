include("../JuliaExtendableTrees/JuliaExtendableTrees.jl")

Random.seed!(2024)

# effect of number of trees on the BostonHousing dataset
#------------------------------------------------------------------------------------

BostonHousing = CSV.read("BostonHousing.csv", DataFrame)
y = BostonHousing[:, :medv]
X = Matrix(BostonHousing[:, Not(:medv)])
oob_errors = Array{Float64}(undef, 16)
train_errors = Array{Float64}(undef, 16)

# test the differences in error from using a number of trees varying from 10, 25, 50, 100, 200, 300, 400, ..., 900, 1000, 1500, 2000, 2500
number_of_trees::Vector{Int} = [10, 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500]
n = length(number_of_trees)
@time begin
    for b in 1:n
        BostonHousing_forest = grow_forest(X, y, "Regression", L_squared_error; max_depth = 10, min_node_size = 5, n_trees = number_of_trees[b], sfrac = 0.7, swr = false, n_features = 7)
        oob_errors[b] = error_Regression(BostonHousing_forest, X, y, true)
        train_errors[b] = error_Regression(BostonHousing_forest, X, y)
        println(b)

        # clear memory before fitting the next forest
        BostonHousing_forest = nothing
    end
end

# 1 means max_depth of 5, 2 a max_depth of 10, 3 a max_depth of 15, 4 a max_depth of 20, 5 means no max_depth
CSV.write("BostonHousing_ntrees2.csv", Tables.table(hcat(number_of_trees ,train_errors, oob_errors)), writeheader = true)
