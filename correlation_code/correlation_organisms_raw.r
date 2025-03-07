
# -------------------------------------------------
# Calculate the correlation between orgnanisms, no filtering
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   

count_matrix <- "test_files/rewritten_test_kraken1.tsv"
results <- "test_files/org_correlation_ww1_test.tsv"


# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_ww1.tsv"

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_ww2.tsv"

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_hg.tsv"

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_all.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$TrueID
rownames(data) <- org_names

data <- data[, -1]  
data <- data[rowSums(data != 0) > 0, ]
data <- log(data + 1)

# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

res <- rcorr(t(data_mat), type = "pearson") # transpose bc default is correlation between columns, and organisms are rows


cor_matrix <- res$r
p_matrix   <- res$P

rownames(cor_matrix) <- rownames(data)
colnames(cor_matrix) <- rownames(data)
rownames(p_matrix)   <- rownames(data)
colnames(p_matrix)   <- rownames(data)

cor_long <- melt(cor_matrix, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Organism1", "Organism2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))



# Function to calculate the percentage of zero-pairs
calculate_zero_percentage <- function(mat) {
  n <- ncol(mat)  # Number of samples/columns
  zero_percentage_matrix <- matrix(0, nrow = nrow(mat), ncol = nrow(mat), 
                                   dimnames = list(rownames(mat), rownames(mat)))
  
  for (i in 1:nrow(mat)) {
    for (j in 1:nrow(mat)) {
      zero_count <- sum(mat[i, ] == 0 & mat[j, ] == 0)  # Count both zero
      zero_percentage_matrix[i, j] <- (zero_count / n) * 100  # Convert to percentage
    }
  }
  return(zero_percentage_matrix)
}

# Compute zero percentage matrix
zero_percentage_matrix <- calculate_zero_percentage(data_mat)

# Convert to long format
zero_long <- melt(zero_percentage_matrix, varnames = c("Organism1", "Organism2"), value.name = "DoubleZeroPercentage")

# Merge with correlation and p-value results
result_df <- merge(result_df, zero_long, by = c("Organism1", "Organism2"))

# Save the updated results
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)