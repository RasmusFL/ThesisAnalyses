# all figures related to the RSF section

using CSV, DataFrames, AlgebraOfGraphics, CairoMakie

# boxplots for pbc, veteran and follic
#------------------------------------------------------------------------------------

# load the data

pbc_error = CSV.read("Error_pbc.csv", DataFrame)
veteran_error = CSV.read("Error_veteran.csv", DataFrame)
cancer_error = CSV.read("Error_cancer.csv", DataFrame)
retinopathy_error = CSV.read("Error_retinopathy.csv", DataFrame)

# make a combined boxplot

B = 100
df = (x = [fill("LR", B); fill("Con", B); fill("LRS", B); fill("ALR", B); fill("C", B);
           fill("LR", B); fill("Con", B); fill("LRS", B); fill("ALR", B); fill("C", B);
           fill("LR", B); fill("Con", B); fill("LRS", B); fill("ALR", B); fill("C", B);
           fill("LR", B); fill("Con", B); fill("LRS", B); fill("ALR", B); fill("C", B)],
      y = [pbc_error.log_rank; pbc_error.conserve; pbc_error.log_rank_score; pbc_error.approx_log_rank; pbc_error.C;
           veteran_error.log_rank; veteran_error.conserve; veteran_error.log_rank_score; veteran_error.approx_log_rank; veteran_error.C;
           cancer_error.log_rank; cancer_error.conserve; cancer_error.log_rank_score; cancer_error.approx_log_rank; cancer_error.C;
           retinopathy_error.log_rank; retinopathy_error.conserve; retinopathy_error.log_rank_score; retinopathy_error.approx_log_rank; retinopathy_error.C],
      l = [fill("pbc", 5 * B); fill("veteran", 5 * B); fill("cancer", 5 * B); fill("retinopathy", 5 * B)])



plt = data(df) * mapping(:x, :y, layout=:l) * visual(BoxPlot, color = "green")
fg_rsf = draw(plt, facet=(; linkxaxes=:none, linkyaxes=:none), axis = (
              xlabel = "Splitting rule",
              ylabel = "Error (C-index)"),
              figure = (; size = (600, 600),
              title = "Error rates for four datasets for different splitting rules",
              titlealign = :center))

save("Figures/rsf.png", fg_rsf, px_per_unit = 3)

# figures for the analysis of peakVO2
#------------------------------------------------------------------------------------

# minimum node size and splitting rules

min_node_size_antn = CSV.read("peakVO2_min_node_size_antn.csv", DataFrame)
min_node_size_error = CSV.read("peakVO2_min_node_size_error.csv", DataFrame)
mns = min_node_size_error.min_node_size

# error plot
df = (; x = [mns; mns; mns; mns; mns],
        y = [min_node_size_error.log_rank; min_node_size_error.conserve; min_node_size_error.log_rank_score;
        min_node_size_error.approx_log_rank; min_node_size_error.C],
        Splitting = [fill("LR", 7); fill("Con", 7); fill("LRS", 7); fill("ALR", 7); fill("C", 7)])
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Splitting)
plt = data(df) * layers * mapping(:x, :y, color = :Splitting)
fg_mns = draw(plt, axis = (xlabel = "Minimum size of a node", xticks = mns,
                       ylabel = "Error rate"),
                       figure = (; size = (600, 400),
                       title = "Error rate for varying minimum node sizes",
                       titlealign = :center))


save("Figures/peakVO2_min_node_size.png", fg_mns, px_per_unit = 3)

# change of sampling scheme

samp = CSV.read("peakVO2_samp.csv", DataFrame)

df = (; x = samp.sfrac, y = samp.error)
layers = visual(Lines) + visual(Scatter)
plt = data(df) * layers * mapping(:x, :y) * visual(color = "green")
fg_samp = draw(plt, axis = (xlabel = "Fraction of data used", xticks = samp.sfrac,
                       ylabel = "Error rate"),
                       figure = (; size = (600, 400),
                       title = "Error rate for varying fractions of data used to fit",
                       titlealign = :center))

save("Figures/peakVO2_samp.png", fg_samp, px_per_unit = 3)

# variations in number of split points

split = CSV.read("peakVO2_split.csv", DataFrame)

df = (; x = split.n_split, y = split.error)
layers = visual(Lines) + visual(Scatter)
plt = data(df) * layers * mapping(:x, :y) * visual(color = "green")
fg_split = draw(plt, axis = (xlabel = "Number of split points", xticks = split.n_split[[1, 3, 5, 6, 7, 8, 9]],
                       ylabel = "Error rate"),
                       figure = (; size = (600, 400),
                       title = "Error rate for varying number of split points",
                       titlealign = :center))

save("Figures/peakVO2_split.png", fg_split, px_per_unit = 3)

# variations in number of available features

features1 = CSV.read("peakVO2_features_nsplit1.csv", DataFrame)
features3 = CSV.read("peakVO2_features_nsplit3.csv", DataFrame)
features10 = CSV.read("peakVO2_features_nsplit10.csv", DataFrame)

df = (; x = [features1.n_features;features3.n_features;features10.n_features],
        y = [features1.error; features3.error; features10.error],
        Splits = [fill("1", 15); fill("3", 15); fill("10", 15)])
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Splits)
plt = data(df) * layers * mapping(:x, :y, color = :Splits)
fg_features = draw(plt, axis = (xlabel = "Number of features", xticks = features1.n_features,
                       ylabel = "Error rate"),
                       figure = (; size = (600, 400),
                       title = "Error rates for varying number of features used in a split",
                       titlealign = :center))

save("Figures/peakVO2_features.png", fg_features, px_per_unit = 3)

# changing the number of trees

trees = CSV.read("peakVO2_trees.csv", DataFrame)

df = (; x = trees.n_trees, y = trees.error)
layers = visual(Lines) + visual(Scatter)
plt = data(df) * layers * mapping(:x, :y) * visual(color = "green")
fg_trees = draw(plt, axis = (xlabel = "Number of trees", xticks = trees.n_trees[[1, 4, 6, 8, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20]],
                       xticklabelrotation = pi/2,
                       ylabel = "Error rate"),
                       figure = (; size = (600, 400),
                       title = "Error rate for varying number of trees",
                       titlealign = :center))

save("Figures/peakVO2_trees.png", fg_trees, px_per_unit = 3)

