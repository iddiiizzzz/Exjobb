
# ------------------------------------------------------------------------------
# Calculate the correlation between orgnanisms, filter out double zeros
# -----------------------------------------------------------------------------


library(Hmisc)      
library(reshape2)   


# count_matrix <- "test_files/rewritten_test_kraken1.tsv"
# results <- "test_files/org_correlation_filtered_test.tsv"

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_filtered_ww1.tsv" 

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_filtered_ww2.tsv" 

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_filtered_hg.tsv" 

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"
# results = "/storage/bergid/correlation/organisms/org_correlation_filtered_all.tsv"


# count_matrix <- "test_files/test_double_zeros.tsv"
# results = "test_files/double_zeros_results.tsv"

count_matrix <- "/storage/koningen/count_matrix.tsv"
results <- "/storage/bergid/correlation/genes/genes_correlation_double_zeros_not_filtered_teeeeeeeeest.tsv"





data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data$GeneNames
rownames(data) <- gene_names

data <- data[, -1]  
# data <- data[(rowSums(data == 0) / ncol(data)) < 0.75, ]
data <- log(data + 1)


# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))



filtered_cor_matrix <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))
filtered_p_matrix <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))

for (i in 1:nrow(data_mat)) {
  print(i)
    for (j in 1:nrow(data_mat)) {

        temp_data <- cbind(data_mat[i, ], data_mat[j, ])
        
        # Replace double-zero values with NA
        double_zero_mask <- (temp_data[,1] == 0 & temp_data[,2] == 0)
        temp_data[double_zero_mask, ] <- NA  # Only remove those specific elements

        # Check if at least two valid pairs exist
        if (sum(complete.cases(temp_data)) > 1) {  
            cor_result <- rcorr(temp_data, type = "pearson")
            filtered_cor_matrix[i, j] <- cor_result$r[1, 2]  # Extract correlation value
            filtered_p_matrix[i,j] <- cor_result$P[1, 2]


        
        }
    }
}


cor_long <- melt(filtered_cor_matrix, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")
p_long   <- melt(filtered_p_matrix,   varnames = c("Gene1", "Gene2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Gene1", "Gene2"))




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
zero_long <- melt(zero_percentage_matrix, varnames = c("Gene1", "Gene2"), value.name = "DoubleZeroPercentage")

# Merge with correlation and p-value results
result_df <- merge(result_df, zero_long, by = c("Gene1", "Gene2"))

# Save the updated results
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)