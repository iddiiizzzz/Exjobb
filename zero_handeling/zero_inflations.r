
# Load necessary libraries
library(pscl)
library(MASS)
library(reshape2)

# "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv" #ida
# "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv" #ellen
# "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv" #ellen
# "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"

#test_files/rewritten_test_kraken1.tsv


# Read your data
data <- read.table("/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)

#filter zeros
data <- data[(rowSums(data == 0) / ncol(data)) < 0.75, ]


# Set TrueID as row names and convert the data to long format
data_long <- melt(data, id.vars = "TrueID", variable.name = "Sample", value.name = "Counts")


# Convert TrueID to factor (for modeling)
data_long$TrueID <- as.factor(data_long$TrueID)

# Log-transform counts only
data_long$Counts <- log(data_long$Counts + 1)

# ZIP model
zip_model <- zeroinfl(Counts ~ TrueID | 1, data = data_long, dist = "poisson")
summary(zip_model)

# ZINB model
zinb_model <- zeroinfl(Counts ~ TrueID | 1, data = data_long, dist = "negbin")
summary(zinb_model)
