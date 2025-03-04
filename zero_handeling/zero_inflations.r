
# Load necessary libraries
library(pscl)
library(MASS)
library(reshape2)

# infile = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv" 
# infile = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv" 
# infile = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"

infile = "test_files/rewritten_test_kraken1.tsv"


data <- read.table(infile, sep = "\t", header = TRUE, stringsAsFactors = FALSE)


# data <- data[(rowSums(data == 0) / ncol(data)) < 0.75, ]
# Filter out rows where all counts are greater than zero
data <- data[apply(data[, -1], 1, function(row) any(row == 0)), ]
data$TrueID <- as.character(data$TrueID)

zero_probabilities_zip <- matrix(0, nrow = nrow(data), ncol = ncol(data) - 1, dimnames = list(data$TrueID, colnames(data)[-1]))
zero_probabilities_zinb <- matrix(0, nrow = nrow(data), ncol = ncol(data) - 1, dimnames = list(data$TrueID, colnames(data)[-1]))

# Set TrueID as row names and convert the data to long format
data_long <- melt(data, id.vars = "TrueID", variable.name = "Sample", value.name = "Counts")

for (i in 1:nrow(data)) {
    row_data <- data[i,-1] # Exclude the TrueID column
    tax_id <- data[i,1] # TrueID for the row

    row_df <- data.frame(Sample = colnames(row_data), Counts = as.numeric(row_data))
    
    
    # ZIP model
    zip_model <- zeroinfl(Counts ~ 1 | 1, data = row_df, dist = "poisson")

    #ZINB model
    zinb_model <- zeroinfl(Counts ~ 1 | 1, data = row_df, dist = "negbin")


    # Predict zero-inflation probabilities for each column
    zip_probs <- predict(zip_model, type = "zero")
    zinb_probs <- predict(zinb_model, type = "zero")

    # Store probabilities in the matrix
    zero_probabilities_zip[tax_id, ] <- zip_probs
    zero_probabilities_zinb[tax_id, ] <- zinb_probs
}

# Save the zero probabilities for further analysis
write.table(zero_probabilities_zip, file = "test_files/zip_probabilities.tsv", sep = "\t", quote = FALSE, col.names = NA)
write.table(zero_probabilities_zinb, file = "test_files/zinb_probabilities.tsv", sep = "\t", quote = FALSE, col.names = NA)
 
print(zip_model)
print(zinb_model)

