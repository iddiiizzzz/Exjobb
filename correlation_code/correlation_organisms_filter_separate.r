library(Hmisc)      
library(reshape2)

# count_matrix_ww1 <- "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# count_matrix_ww2 <- "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# count_matrix_hg <- "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"

# results <- "/storage/bergid/correlation/results_org_correlation_all_log_sep75.tsv"

count_matrix_ww1 <- "test_files/rewritten_test_kraken1.tsv"
count_matrix_ww2 <- "test_files/rewritten_test_kraken2.tsv"
count_matrix_hg <- "test_files/rewritten_test_kraken3.tsv"
count_matrix <- "test_files/test_all_organisms.tsv"

results <- "test_files/filter_75"

# Function to read and filter data
read_and_filter <- function(file) {
  data <- read.table(file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
  org_names <- data$TrueID
  rownames(data) <- org_names
  data <- data[, -1]  
  data <- data[(rowSums(data == 0) / ncol(data)) < 0.75, ]
  return(rownames(data))
}

# Filter each file separately
org_names_ww1 <- read_and_filter(count_matrix_ww1)
org_names_ww2 <- read_and_filter(count_matrix_ww2)
org_names_hg <- read_and_filter(count_matrix_hg)

# Combine the filtered organism names
filtered_orgs <- unique(c(org_names_ww1, org_names_ww2, org_names_hg))

# Read the combined file and filter it based on the combined filtered organisms
data_combined <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(data_combined) <- data_combined$TrueID
data_combined <- data_combined[, -1]
data_combined <- data_combined[rownames(data_combined) %in% filtered_orgs, ]

# Log-transform the filtered data
data_combined <- log(data_combined + 1)

# Convert data to a numeric matrix while preserving row and column names
data_mat <- as.matrix(data_combined)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data_combined), colnames(data_combined)))

# Compute Pearson correlations and corresponding p-values
res <- rcorr(t(data_mat), type = "pearson")

cor_matrix <- res$r
p_matrix <- res$P

rownames(cor_matrix) <- rownames(data_combined)
colnames(cor_matrix) <- rownames(data_combined)
rownames(p_matrix) <- rownames(data_combined)
colnames(p_matrix) <- rownames(data_combined)



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

# Write the final data frame to a tab-delimited file with a header 
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)