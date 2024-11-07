# all testing related to the section mlpre

using Random, Base.Threads, StatsBase, CSV, DataFrames, TidierPlots

include("../JuliaExtendableTrees/splitter.jl")
include("../JuliaExtendableTrees/tree.jl")
include("../JuliaExtendableTrees/splitter.jl")
include("../JuliaExtendableTrees/forest.jl")
include("../JuliaExtendableTrees/predict.jl")
include("../JuliaExtendableTrees/error.jl")

Random.seed!(2024)

# effect of using entropy or Gini coefficient on the iris data set
#------------------------------------------------------------------------------------

# start by renaming the three species to
# 1: setosa
# 2: versicolor
# 3: virginica
iris = CSV.read("iris.csv", DataFrame)
for j in 1:size(iris, 1)
    if iris[j, 5] == "setosa"
        iris[j, 5] = "1"
    elseif iris[j, 5] == "versicolor"
        iris[j, 5] = "2"
    elseif iris[j, 5] == "virginica"
        iris[j, 5] = "3"
    end
end

iris.Species = parse.(Float64, iris.Species)

y = iris[:, :Species]
X = Matrix(iris[:, Not(:Species)])

B = 100
oob_errors_Gini = Array{Float64}(undef, B)
train_errors_Gini = Array{Float64}(undef, B)
oob_errors_Entropy = Array{Float64}(undef, B)
train_errors_Entropy = Array{Float64}(undef, B)

#grow_forest(X, y, type::String, L, max_depth, min_node_size, n_features, n_split, n_trees, sfrac, swr)
# max_depth = 5, min_node_size = 10, n_features = 2, n_split = 10, n_trees = 1000, sfrac = 1, swr = true (ordinary bootstrapping)
@time begin
    for b in 1:B
        println(b)
        iris_forest_Gini = grow_forest(X, y, "Classification", L_Gini_coefficient, 5, 5, Int(round(sqrt(size(X, 2)))), 10, 1000, 1.0, true)
        oob_errors_Gini[b] = error_Classification(iris_forest_Gini, X, y, true)
        train_errors_Gini[b] = error_Classification(iris_forest_Gini, X, y)
        iris_forest_Entropy = grow_forest(X, y, "Classification", L_Entropy, 5, 5, Int(round(sqrt(size(X, 2)))), 10, 1000, 1.0, true)
        oob_errors_Entropy[b] = error_Classification(iris_forest_Entropy, X, y, true)
        train_errors_Entropy[b] = error_Classification(iris_forest_Entropy, X, y)
    end
end

# conclusion: Each vector only gives two or three distinct values. No difference in the OOB errors, but it is
# impossible to conclude anything interesting



