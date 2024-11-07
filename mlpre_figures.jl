# all plots related to the mlpre section

using CSV, DataFrames, AlgebraOfGraphics, CairoMakie, PalmerPenguins

# just a test with Palmer's penguin data
penguins = dropmissing(DataFrame(PalmerPenguins.load()))

axis = (width = 225, height = 225)
penguin_frequency = data(penguins) * frequency() * mapping(:species)

draw(penguin_frequency; axis = axis)

# example code useful for drawing error rates as a function of something
N = 40
x = [1:N; 1:N]
y = [cumsum(randn(N)); cumsum(randn(N))]
Group = [fill("a", N); fill("b", N)]

df = (; x, y, Group)

layers = visual(Lines) + visual(Scatter) * mapping(marker = :Group)
plt = data(df) * layers * mapping(:x, :y, color = :Group)

fg = draw(plt, axis = (xlabel = "Minimum node size", xticks = 0:5:40, ylabel = "ylabel"))

# facet wrap example code
df = (x=rand(100), y=rand(100), l=rand(["a", "b", "c", "d", "e"], 100))
plt = data(df) * mapping(:x, :y, layout=:l)
draw(plt)

# for specifying layout of columns and rows
draw(plt, scales(Layout = (; palette = [(1, 1), (2, 1), (3, 1), (1, 2), (2, 2)])))

# the wine dataset
#------------------------------------------------------------------------------------

# 1. sampling scheme for both entropy and the Gini coefficient

# plot for the Gini coefficient

sampling_Gini = CSV.read("wine_sampling_Gini.csv", DataFrame)

Error = [fill("Train", 10); fill("OOB", 10)]
x = [0.1:0.1:1; 0.1:0.1:1]

y = [sampling_Gini.Training_error; sampling_Gini.OOB_error]
df = (; x, y, Error)
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error)
fg_Gini = draw(plt, axis = (xlabel = "Fraction of data used", xticks = 0.1:0.1:1,
                       ylabel = "Error rate"))

# plot for the Entropy

sampling_Entropy = CSV.read("wine_sampling_Entropy.csv", DataFrame)

y = [sampling_Entropy.Training_error; sampling_Entropy.OOB_error]
df = (; x, y, Error)
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error)
fg_Entropy = draw(plt, axis = (xlabel = "Fraction of data used", xticks = 0.1:0.1:1,
                       ylabel = "Error rate"))

# combined plot

df = (x = [0.1:0.1:1; 0.1:0.1:1; 0.1:0.1:1; 0.1:0.1:1],
      y = [sampling_Gini.Training_error; sampling_Gini.OOB_error; sampling_Entropy.Training_error; sampling_Entropy.OOB_error],
      Error = [fill("Train", 10); fill("OOB", 10); fill("Train", 10); fill("OOB", 10)],
      l = [fill("Gini coefficient", 20); fill("Entropy", 20)])

layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error, layout = :l)
fg = draw(plt, axis = (xlabel = "Fraction of data used", xticks = 0.1:0.1:1,
                       ylabel = "Error rate"), 
                       figure = (; size = (800, 400),
                       title = "Error rates for varying fractions of data used to fit",
                       titlealign = :center))

save("Figures/sampling_plot.png", fg, px_per_unit = 3)

# 2. node depth

nodedepth = CSV.read("wine_nodedepth.csv", DataFrame)
df = (; x = [nodedepth.max_depth; nodedepth.max_depth],
        y = [nodedepth.Training_error; nodedepth.OOB_error],
        Error = [fill("Train", 19); fill("OOB", 19)])
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error)
fg_nd = draw(plt, axis = (xlabel = "Maximum node depth", xticks = 2:1:20,
                       ylabel = "Error rate"),
                       figure = (; size = (600, 400),
                       title = "Error rates for varying maximum node depths",
                       titlealign = :center))

save("Figures/node_depth_plot.png", fg_nd, px_per_unit = 3)

# 3. minimum node size

nodesize = CSV.read("wine_min_node_size.csv", DataFrame)
df = (; x = [nodesize.min_node_size; nodesize.min_node_size],
        y = [nodesize.Training_error; nodesize.OOB_error],
        Error = [fill("Train", 30); fill("OOB", 30)])
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error)
fg_ns = draw(plt, axis = (xlabel = "Minimum node size", xticks = 1:1:30,
                       ylabel = "Error rate"),
                       figure = (; size = (800, 600),
                       title = "Error rates for varying minimum node sizes",
                       titlealign = :center))

save("Figures/min_node_size_plot.png", fg_ns, px_per_unit = 3)

# the BostonHousing dataset
#------------------------------------------------------------------------------------

# 1. number of trees

# consider the data for max_depth = 10
ntrees = CSV.read("BostonHousing_ntrees2.csv", DataFrame)
df = (; x = [ntrees.n_trees; ntrees.n_trees],
        y = [ntrees.Training_error; ntrees.OOB_error],
        Error = [fill("Train", 16); fill("OOB", 16)])
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error)
fg_nt = draw(plt, axis = (xlabel = "Number of trees", xticks = ntrees.n_trees[[1; 4:16]],
                xticklabelrotation = pi/2,
                ylabel = "Error rate"),
                figure = (; size = (800, 400),
                title = "Error rates for varying number of trees",
                titlealign = :center))

save("Figures/n_trees_plot.png", fg_nt, px_per_unit = 3)

# 2. number of features

nfeatures = CSV.read("BostonHousing_nfeatures.csv", DataFrame)
df = (; x = [nfeatures.n_features; nfeatures.n_features],
        y = [nfeatures.Training_error; nfeatures.OOB_error],
        Error = [fill("Train", 13); fill("OOB", 13)])
layers = visual(Lines) + visual(Scatter) * mapping(marker = :Error)
plt = data(df) * layers * mapping(:x, :y, color = :Error)
fg_nf = draw(plt, axis = (xlabel = "Number of features", xticks = nfeatures.n_features,
                ylabel = "Error rate"),
                figure = (; size = (800, 400),
                title = "Error rates for varying number of features used in a split",
                titlealign = :center))

save("Figures/n_features_plot.png", fg_nf, px_per_unit = 3)