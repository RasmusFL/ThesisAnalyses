# all testing related to the section mlpre

include("../JuliaExtendableTrees/JuliaExtendableTrees.jl")

Random.seed!(2024)

# effect of number of features on the BostonHousing dataset
#------------------------------------------------------------------------------------

BostonHousing = CSV.read("BostonHousing.csv", DataFrame)
y = BostonHousing[:, :medv]
X = Matrix(BostonHousing[:, Not(:medv)])
oob_errors = Array{Float64}(undef, 13)
train_errors = Array{Float64}(undef, 13)

# grow_forest(X, y, type::String, L, max_depth, min_node_size, n_features, n_split, n_trees, sfrac, swr)

# test the differences in error from using a number of features varying between 1 and 13
@time begin
    for b in 1:13
        BostonHousing_forest = grow_forest(X, y, "Regression", L_squared_error; max_depth = 5, min_node_size = 5, n_features = b, sfrac = 0.7, swr = false)
        oob_errors[b] = error_Regression(BostonHousing_forest, X, y, true)
        train_errors[b] = error_Regression(BostonHousing_forest, X, y)
        println(b)

        # clear memory before fitting the next forest
        BostonHousing_forest = nothing
    end
end

CSV.write("BostonHousing_nfeatures.csv", Tables.table(hcat(1:13 ,train_errors, oob_errors)), writeheader = true)