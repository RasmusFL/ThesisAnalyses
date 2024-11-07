# all testing related to the dataset peakVO2

include("../JuliaExtendableTrees/JuliaExtendableTrees.jl")

# read in the data
df = CSV.read("peakVO2.csv", DataFrame)
y = Matrix(df[:, [:ttodead, :died]])
X = Matrix(df[:, Not([:ttodead, :died])])

# min_node_size and splitting rules
#------------------------------------------------------------------------------------

Random.seed!(2024)

# min_node_sizes to check
sizes = [5, 10, 15, 20, 30, 40, 50]

# save errors and average number of terminal nodes
error_mns_lr = zeros(Float64, 7)
antn_mns_lr = zeros(Float64, 7)

error_mns_con = zeros(Float64, 7)
antn_mns_con = zeros(Float64, 7)

error_mns_lrs = zeros(Float64, 7)
antn_mns_lrs = zeros(Float64, 7)

error_mns_alr = zeros(Float64, 7)
antn_mns_alr = zeros(Float64, 7)

error_mns_C = zeros(Float64, 7)
antn_mns_C = zeros(Float64, 7)

@time begin
    for i in 1:length(sizes)
        # log-rank
        forest = grow_forest(X, y, "Survival", L_log_rank; min_node_size = sizes[i], n_trees = 1000, sfrac = 1.0, swr = true)
        error_mns_lr[i] = OOB_error(forest)
        antn_mns_lr[i] = forest.avr_number_terminal_nodes
        forest = nothing    # free memory
    
        # conserve
        forest = grow_forest(X, y, "Survival", L_conserve; min_node_size = sizes[i], n_trees = 1000, sfrac = 1.0, swr = true)
        error_mns_con[i] = OOB_error(forest)
        antn_mns_con[i] = forest.avr_number_terminal_nodes
        forest = nothing    # free memory
    
        # log-rank-score
        forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = sizes[i], n_trees = 1000, sfrac = 1.0, swr = true)
        error_mns_lrs[i] = OOB_error(forest)
        antn_mns_lrs[i] = forest.avr_number_terminal_nodes
        forest = nothing    # free memory
    
        # approximate log-rank
        forest = grow_forest(X, y, "Survival", L_approx_log_rank; min_node_size = sizes[i], n_trees = 1000, sfrac = 1.0, swr = true)
        error_mns_alr[i] = OOB_error(forest)
        antn_mns_alr[i] = forest.avr_number_terminal_nodes
        forest = nothing    # free memory
    
        # C-index
        forest = grow_forest(X, y, "Survival", L_C; min_node_size = sizes[i], n_trees = 1000, sfrac = 1.0, swr = true)
        error_mns_C[i] = OOB_error(forest)
        antn_mns_C[i] = forest.avr_number_terminal_nodes
        forest = nothing    # free memory

        println("Iteration: ", i, "/7")
    end
end

# total time: 6489.334204 seconds (about 108 minutes)

CSV.write("peakVO2_min_node_size_error.csv", 
          Tables.table(hcat(sizes, error_mns_lr, error_mns_con, error_mns_lrs, error_mns_alr, error_mns_C)), writeheader = true)

CSV.write("peakVO2_min_node_size_antn.csv", 
          Tables.table(hcat(sizes, antn_mns_lr, antn_mns_con, antn_mns_lrs, antn_mns_alr, antn_mns_C)), writeheader = true)

# conclusion: log_rank_score with min_node_size = 20 is best

# sampling
#------------------------------------------------------------------------------------

Random.seed!(2024)

error_samp = zeros(Float64, 10)
antn_samp = zeros(Float64, 10)

for i in 1:9
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 1000, sfrac = i * 0.1, swr = false)
    error_samp[i] = OOB_error(forest)
    antn_samp[i] = forest.avr_number_terminal_nodes
    forest = nothing    # free memory
    println("Iteration: ", i)
end

# the case sfrac = 1.0 is classic bootstrap (swr = true)
forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 1000, sfrac = 1.0, swr = true)
error_samp[10] = OOB_error(forest)
antn_samp[10] = forest.avr_number_terminal_nodes
forest = nothing

CSV.write("peakVO2_samp.csv", 
          Tables.table(hcat([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0], error_samp, antn_samp)), writeheader = true)

# best result is for sfrac = 1.0. Second best is sfrac = 0.6, so we use this for testing, but sfrac = 1.0 for the final model

# n_split
#------------------------------------------------------------------------------------

Random.seed!(2024)

splits = [1, 2, 3, 4, 5, 10, 25, 50, 100]
error_split = zeros(Float64, 9)
antn_split = zeros(Float64, 9)

for i in 1:9
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 1000, sfrac = 0.6, swr = false, n_split = splits[i])
    error_split[i] = OOB_error(forest)
    antn_split[i] = forest.avr_number_terminal_nodes
    forest = nothing    # free memory
    println("Iteration: ", i)
end

CSV.write("peakVO2_split.csv", 
          Tables.table(hcat(splits, error_split, antn_split)), writeheader = true)

# best result is n_split = 1 (hmm, strange). n_split = 3 is also quite good

# n_features
#------------------------------------------------------------------------------------

Random.seed!(2024)

features = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 39]
error_features = zeros(Float64, 15)
antn_features = zeros(Float64, 15)

for i in 1:15
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 1000, n_features = features[i], sfrac = 0.6, swr = false, n_split = 10)
    error_features[i] = OOB_error(forest)
    antn_features[i] = forest.avr_number_terminal_nodes
    forest = nothing    # free memory
    println("Iteration: ", i)
end

CSV.write("peakVO2_features_nsplit10.csv", 
          Tables.table(hcat(features, error_features, antn_features)), writeheader = true)

# n_features = 8 is best for n_split = 1, 10 and n_features = 9 is best for n_split = 3

# intermezzo:

final_forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 1000, n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
final_error = OOB_error(final_forest)

(1 - 0.705) - final_error   # 0.0035925308742223994

# 0.0035925308742223994 lower error than Hsich et al.

# do more trees make a difference?
final_forest_2000 = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 2000, n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
final_error_2000 = OOB_error(final_forest_2000)

(1 - 0.705) - final_error_2000  # 0.0037531686237405326

# alright, the number of trees actually matter somewhat! We should investigate this

# n_trees
#------------------------------------------------------------------------------------

Random.seed!(2024)

trees = [25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
error_trees = zeros(Float64, 20)
antn_trees = zeros(Float64, 20)

# note that it is important to use sfrac = 1.0 here (otherwise we don't see the same phenomenon as above)
for i in 1:20
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = trees[i], n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
    error_trees[i] = OOB_error(forest)
    antn_trees[i] = forest.avr_number_terminal_nodes
    forest = nothing    # free memory
    println("Iteration: ", i)
end

CSV.write("peakVO2_trees.csv", 
          Tables.table(hcat(trees, error_trees, antn_trees)), writeheader = true)

# interestingly, 500 trees is best followed by 2500 (but this is for sfrac = 0.6, swr = false)

#now choose the final forest

Random.seed!(2024)

final_forest_1000 = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 1000, n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
final_error_1000 = OOB_error(final_forest_1000)

(1 - 0.705) - final_error   # 0.0038670272483989354 (okay, good)

# use 2000 trees as in the article
final_forest_2000 = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 2000, n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
final_error_2000 = OOB_error(final_forest_2000)

(1 - 0.705) - final_error_2000  # 0.004069148372792597 ()

final_forest_2500 = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 2500, n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
final_error_2500 = OOB_error(final_forest_2500)

(1 - 0.705) - final_error_2500  # 0.004457503371627536 (okay, nice!)

final_forest_5000 = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 20, n_trees = 5000, n_features = 8, sfrac = 1.0, swr = true, n_split = 1)
final_error_5000 = OOB_error(final_forest_5000)

(1 - 0.705) - final_error_5000  # 0.004450442371648711 (negligible difference from 2500)

# This is our final choice of model. It seems that the behaviour of the error varies randomly when changing the number of trees
# 2000 trees is better than 1000 here, but in the analysis before, 900 was best. 2000 trees should be more stable for new data

# preliminary testing
#------------------------------------------------------------------------------------

#@time begin
#    peakVO2_forest = grow_forest(X, y, "Survival", L_C; min_node_size = 30, n_trees = 1000, sfrac = 1.0, swr = true)
#end

#OOB_error(peakVO2_forest)

# results for sfrac = 1.0, swr = true, L = L_log_rank
# n_trees = 2000, min_node_size = 15: 0.2966979233599062
# n_trees = 1000, min_node_size = 15: the same
# n_trees = 1000, min_node_size = 10: 0.29746139398261584
# n_trees = 1000, min_node_size = 20: 0.2974419762326741
# n_trees = 1000, min_node_size = 30: 0.2991860432274419

# results for sfrac = 1.0, swr = true, n_trees = 1000, L = L_conserve
# min_node_size = 15: 0.3035656284643031
# min_node_size = 20: 0.3042673153371981
# min_node_size = 30: 0.3042752589621742

# results for sfrac = 1.0, swr = true, n_trees = 1000, L = L_log_rank_score
# min_node_size = 30: 0.2967420546097739

# results for sfrac = 1.0, swr = true, n_trees = 1000, L = L_approx_log_rank
# min_node_size = 30: 0.2979018238562945

# results for sfrac = 1.0, swr = true, n_trees = 1000, L = L_C
# min_node_size = 30: 0.3335987092492039

