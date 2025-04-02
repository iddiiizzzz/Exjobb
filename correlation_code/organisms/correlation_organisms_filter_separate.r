
# -------------------------------------------------
# Calculate the correlation between orgnanisms
# filter 75% zeroes in all organism files separately
# save together if one fullfills the limit
# -------------------------------------------------

library(Hmisc)      
library(reshape2)

count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms_filtered.tsv" ##ellen tmux correlation
results <- "/storage/bergid/correlation/organisms/org_correlation_separate_filtering.tsv"

# count_matrix <- "test_files/test_all_organisms.tsv"
# results <- "test_files/filter_75"



data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(data) <- data$OrgNames
data <- data[, -1]  

# Convert data to a numeric matrix while preserving row and column names
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

cat("reading data done\n")
res <- rcorr(t(data_mat), type = "pearson")

cor_matrix <- res$r
p_matrix <- res$P

rownames(cor_matrix) <- rownames(data)
colnames(cor_matrix) <- rownames(data)
rownames(p_matrix) <- rownames(data)
colnames(p_matrix) <- rownames(data)


cat("correlation done\n")
# Reshape matrices from wide to long format
cor_long <- melt(cor_matrix, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long <- melt(p_matrix, varnames = c("Organism1", "Organism2"), value.name = "pValue")

# Merge the two data frames by matching Organism1 and Organism2
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

# Reshape matrices from wide to long format
cor_long <- melt(cor_matrix, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long <- melt(p_matrix, varnames = c("Organism1", "Organism2"), value.name = "pValue")
zero_long <- melt(zero_percentage_matrix, varnames = c("Organism1", "Organism2"), value.name = "DoubleZeroPercentage")

# Merge the data frames
result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))
result_df <- merge(result_df, zero_long, by = c("Organism1", "Organism2"))
cat("writing\n")
# Write the final data frame to a tab-delimited file with a header 
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)