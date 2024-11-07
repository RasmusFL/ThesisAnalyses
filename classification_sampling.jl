# all testing related to the section mlpre

include("../JuliaExtendableTrees/JuliaExtendableTrees.jl")

Random.seed!(2024)

# effect of sampling scheme on the wine dataset
#------------------------------------------------------------------------------------

wine = CSV.read("wine.csv", DataFrame)
y = wine[:, :quality]
X = Matrix(wine[:, Not(:quality)])
oob_errors = Array{Float64}(undef, 10)
train_errors = Array{Float64}(undef, 10)

# max_depth = 10, min_node_size = 10, n_features = 3, n_split = 10, n_trees = 1000, 
@time begin
    for b in 1:9
        wine_forest = grow_forest(X, y, "Classification", L_Gini_coefficient; max_depth = 10, min_node_size = 10, sfrac = 0.1 + 0.1*(b - 1), swr = false)
        oob_errors[b] = error_Classification(wine_forest, X, y, true)
        train_errors[b] = error_Classification(wine_forest, X, y)
        println(b)
    end
    # full bootstrap
    wine_forest = grow_forest(X, y, "Classification", L_Gini_coefficient; max_depth = 10, min_node_size = 10, sfrac = 1.0, swr = true)
    oob_errors[10] = error_Classification(wine_forest, X, y, true)
    train_errors[10] = error_Classification(wine_forest, X, y)
end

CSV.write("wine_sampling_Gini.csv", Tables.table(hcat(train_errors, oob_errors)), writeheader = true)

