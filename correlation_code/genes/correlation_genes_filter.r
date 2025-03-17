
# -------------------------------------------------
# Calculate the correlation between genes, filter 75% zeros
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   

# count_matrix <- "test_files/test_gene_count_matrix.tsv"
# results <- "test_files/gene_correlation_results_test75.tsv"

count_matrix = "/storage/koningen/count_matrix.tsv"
results = "/storage/bergid/correlation/genes/gene_correlation_filtered_90.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data$GeneNames
rownames(data) <- gene_names

data <- data[, -1]  
data <- data[(rowSums(data == 0) / ncol(data)) < 0.90, ]
data <- log(data + 1)

# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

res <- rcorr(t(data_mat), type = "pearson") # transpose bc default is correlation between columns, and genes are rows


cor_matrix <- res$r
p_matrix   <- res$P

rownames(cor_matrix) <- rownames(data)
colnames(cor_matrix) <- rownames(data)
rownames(p_matrix)   <- rownames(data)
colnames(p_matrix)   <- rownames(data)

cor_long <- melt(cor_matrix, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Gene1", "Gene2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Gene1", "Gene2"))



# Function to calculate the percentage of zero-pairs
calculate_zero_percentage <- function(mat) {
  n <- ncol(mat)  # Number of samples/columns
  zero_percentage_matrix <- matrix(0, nrow = nrow(mat), ncol = nrow(mat), 
                                   dimnames = list(rownames(mat), rownames(mat)))
  
  for (i in 1:nrow(mat)) {
    for (j in 1:nrow(mat)) {
      zero_count <- sum(mat[i, ] == 0 & mat[j, ] == 0)  # Count when both zero
      zero_percentage_matrix[i, j] <- (zero_count / n) * 100  # Percentage
    }
  }
  return(zero_percentage_matrix)
}

zero_percentage_matrix <- calculate_zero_percentage(data_mat)
zero_long <- melt(zero_percentage_matrix, varnames = c("Gene1", "Gene2"), value.name = "DoubleZeroPercentage") # Long format
result_df <- merge(result_df, zero_long, by = c("Gene1", "Gene2")) # Merge correlation and p-values

# Save the updated results
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

