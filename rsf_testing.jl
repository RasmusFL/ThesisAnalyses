# all testing done on the datasets pbc, veteran and follic

include("../JuliaExtendableTrees/JuliaExtendableTrees.jl")

# number of bootstrap replicates
B = 100

# pbc
#------------------------------------------------------------------------------------

# read in data
pbc = CSV.read("pbc.csv", DataFrame)
y = Matrix{Float64}(pbc[:, [:days, :status]])
X = Matrix{Float64}(pbc[:, Not([:days, :status])])
n = size(X, 1)

# log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
pbc_lr_error = zeros(Float64, B)
pbc_lr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    pbc_lr_error[b] = OOB_error(forest)
    pbc_lr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# conservation of events splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
pbc_ce_error = zeros(Float64, B)
pbc_ce_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_conserve; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    pbc_ce_error[b] = OOB_error(forest)
    pbc_ce_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# log rank score splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
pbc_lrs_error = zeros(Float64, B)
pbc_lrs_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    pbc_lrs_error[b] = OOB_error(forest)
    pbc_lrs_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# approximate log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
pbc_alr_error = zeros(Float64, B)
pbc_alr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_approx_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    pbc_alr_error[b] = OOB_error(forest)
    pbc_alr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# C-index splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
pbc_c_error = zeros(Float64, B)
pbc_c_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_C; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    pbc_c_error[b] = OOB_error(forest)
    pbc_c_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

CSV.write("Avr_num_terminal_nodes_pbc.csv", 
          Tables.table(hcat(pbc_lr_antn, pbc_ce_antn, pbc_lrs_antn, pbc_alr_antn, pbc_c_antn)), writeheader = true)

CSV.write("Error_pbc.csv", Tables.table(hcat(pbc_lr_error, pbc_ce_error, pbc_lrs_error, pbc_alr_error, pbc_c_error)), writeheader = true)

# veteran
#------------------------------------------------------------------------------------

# read in data
veteran = CSV.read("veteran.csv", DataFrame)
y = Matrix{Float64}(veteran[:, [:time, :status]])
X = Matrix{Float64}(veteran[:, Not([:time, :status])])
n = size(X, 1)

# log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
veteran_lr_error = zeros(Float64, B)
veteran_lr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    veteran_lr_error[b] = OOB_error(forest)
    veteran_lr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# conservation of events splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
veteran_ce_error = zeros(Float64, B)
veteran_ce_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_conserve; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    veteran_ce_error[b] = OOB_error(forest)
    veteran_ce_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# log rank score splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
veteran_lrs_error = zeros(Float64, B)
veteran_lrs_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    veteran_lrs_error[b] = OOB_error(forest)
    veteran_lrs_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# approximate log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
veteran_alr_error = zeros(Float64, B)
veteran_alr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_approx_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    veteran_alr_error[b] = OOB_error(forest)
    veteran_alr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# C-index splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
veteran_c_error = zeros(Float64, B)
veteran_c_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_C; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    veteran_c_error[b] = OOB_error(forest)
    veteran_c_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

CSV.write("Avr_num_terminal_nodes_veteran.csv", 
          Tables.table(hcat(veteran_lr_antn, veteran_ce_antn, veteran_lrs_antn, veteran_alr_antn, veteran_c_antn)), writeheader = true)

CSV.write("Error_veteran.csv", Tables.table(hcat(veteran_lr_error, veteran_ce_error, veteran_lrs_error, veteran_alr_error, veteran_c_error)), writeheader = true)

# follic (ignore this, this data is just pbc due to a mistake in the R document)
#------------------------------------------------------------------------------------

# read in data
follic = CSV.read("follic.csv", DataFrame)
y = Matrix{Float64}(follic[:, [:days, :status]])
X = Matrix{Float64}(follic[:, Not([:days, :status])])
n = size(X, 1)

# log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
follic_lr_error = zeros(Float64, B)
follic_lr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    follic_lr_error[b] = OOB_error(forest)
    follic_lr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# conservation of events splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
follic_ce_error = zeros(Float64, B)
follic_ce_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_conserve; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    follic_ce_error[b] = OOB_error(forest)
    follic_ce_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# log rank score splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
follic_lrs_error = zeros(Float64, B)
follic_lrs_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    follic_lrs_error[b] = OOB_error(forest)
    follic_lrs_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# approximate log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
follic_alr_error = zeros(Float64, B)
follic_alr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_approx_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    follic_alr_error[b] = OOB_error(forest)
    follic_alr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# C-index splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
follic_c_error = zeros(Float64, B)
follic_c_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_C; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    follic_c_error[b] = OOB_error(forest)
    follic_c_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

CSV.write("Avr_num_terminal_nodes_follic.csv", 
          Tables.table(hcat(follic_lr_antn, follic_ce_antn, follic_lrs_antn, follic_alr_antn, follic_c_antn)), writeheader = true)

CSV.write("Error_follic.csv", Tables.table(hcat(follic_lr_error, follic_ce_error, follic_lrs_error, follic_alr_error, follic_c_error)), writeheader = true)

# cancer
#------------------------------------------------------------------------------------

# read in data
cancer = CSV.read("cancer.csv", DataFrame)
y = Matrix{Float64}(cancer[:, [:time, :status]])
X = Matrix{Float64}(cancer[:, Not([:time, :status])])
n = size(X, 1)

# log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
cancer_lr_error = zeros(Float64, B)
cancer_lr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    cancer_lr_error[b] = OOB_error(forest)
    cancer_lr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# conservation of events splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
cancer_ce_error = zeros(Float64, B)
cancer_ce_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_conserve; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    cancer_ce_error[b] = OOB_error(forest)
    cancer_ce_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# log rank score splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
cancer_lrs_error = zeros(Float64, B)
cancer_lrs_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    cancer_lrs_error[b] = OOB_error(forest)
    cancer_lrs_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# approximate log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
cancer_alr_error = zeros(Float64, B)
cancer_alr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_approx_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    cancer_alr_error[b] = OOB_error(forest)
    cancer_alr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# C-index splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
cancer_c_error = zeros(Float64, B)
cancer_c_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_C; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    cancer_c_error[b] = OOB_error(forest)
    cancer_c_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

CSV.write("Avr_num_terminal_nodes_cancer.csv", 
          Tables.table(hcat(cancer_lr_antn, cancer_ce_antn, cancer_lrs_antn, cancer_alr_antn, cancer_c_antn)), writeheader = true)

CSV.write("Error_cancer.csv", Tables.table(hcat(cancer_lr_error, cancer_ce_error, cancer_lrs_error, cancer_alr_error, cancer_c_error)), writeheader = true)

# retinopathy
#------------------------------------------------------------------------------------

# read in data
retinopathy = CSV.read("retinopathy.csv", DataFrame)
y = Matrix{Float64}(retinopathy[:, [:futime, :status]])
X = Matrix{Float64}(retinopathy[:, Not([:futime, :status])])
n = size(X, 1)

# log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
retinopathy_lr_error = zeros(Float64, B)
retinopathy_lr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    retinopathy_lr_error[b] = OOB_error(forest)
    retinopathy_lr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# conservation of events splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
retinopathy_ce_error = zeros(Float64, B)
retinopathy_ce_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_conserve; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    retinopathy_ce_error[b] = OOB_error(forest)
    retinopathy_ce_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# log rank score splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
retinopathy_lrs_error = zeros(Float64, B)
retinopathy_lrs_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_log_rank_score; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    retinopathy_lrs_error[b] = OOB_error(forest)
    retinopathy_lrs_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# approximate log rank splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
retinopathy_alr_error = zeros(Float64, B)
retinopathy_alr_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_approx_log_rank; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    retinopathy_alr_error[b] = OOB_error(forest)
    retinopathy_alr_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

# C-index splitting

Random.seed!(2024)

# vectors for saving errors and average number of terminal nodes
retinopathy_c_error = zeros(Float64, B)
retinopathy_c_antn = zeros(Float64, B)

for b in 1:B
    # make bootstrap sample
    samp = sample(1:n, n, replace = true)
    Xb = X[samp, :]
    yb = y[samp, :]
    forest = grow_forest(X, y, "Survival", L_C; min_node_size = 15, n_trees = 1000, sfrac = 1.0, swr = true)
    
    # save errors and average number of terminal nodes
    retinopathy_c_error[b] = OOB_error(forest)
    retinopathy_c_antn[b] = forest.avr_number_terminal_nodes

    # free memory before fitting next forest
    forest = nothing

    # done with the b'th iteration
    println(b)
end

CSV.write("Avr_num_terminal_nodes_retinopathy.csv", 
          Tables.table(hcat(retinopathy_lr_antn, retinopathy_ce_antn, retinopathy_lrs_antn, retinopathy_alr_antn, retinopathy_c_antn)), writeheader = true)

CSV.write("Error_retinopathy.csv", Tables.table(hcat(retinopathy_lr_error, retinopathy_ce_error, retinopathy_lrs_error, retinopathy_alr_error, retinopathy_c_error)), writeheader = true)
