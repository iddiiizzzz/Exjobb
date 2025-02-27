
# Load necessary libraries
library(pscl)
library(MASS)
library(reshape2)

# "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"

#test_files/rewritten_test_kraken1.tsv


# Read your data
data <- read.table("/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)


# Set TrueID as row names and convert the data to long format
data_long <- melt(data, id.vars = "TrueID", variable.name = "Sample", value.name = "Counts")

data_long <- data_long[(rowSums(data_long == 0) / ncol(data_long)) < 0.75, ]
data_long <- log(data_long + 1)

# ZIP model
zip_model <- zeroinfl(Counts ~ TrueID | 1, data = data_long, dist = "poisson")
summary(zip_model)

# ZINB model
zinb_model <- zeroinfl(Counts ~ TrueID | 1, data = data_long, dist = "negbin")
summary(zinb_model)
