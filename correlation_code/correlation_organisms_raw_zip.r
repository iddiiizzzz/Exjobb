
# -------------------------------------------------
# Calculate the correlation between orgnanisms
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   


count_matrix <- "test_files/rewritten_test_kraken1.tsv"
zip_prob_file <- "test_files/zip_probabilities.tsv"
results <- "test_files/results_org_correlation_ww1_zip_test.tsv"

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww.tsv"
# results = "/storage/bergid/correlation/organisms/results_org_correlation_ww_log.tsv"
# zip_prob_file <- "/storage/bergid/zero_inflations/zip_probabilities_ww.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# results = "/storage/bergid/correlation/organisms/results_org_correlation_hg_log.tsv"
# zip_prob_file <- "/storage/bergid/zero_inflations/zip_probabilities_hg.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"
# results = "/storage/bergid/correlation/organisms/results_org_correlation_all_log.tsv"
# zip_prob_file <- ""

# results = "/storage/bergid/correlation/results_org_correlation_all_log_switchLogSum.tsv"

data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$TrueID
rownames(data) <- org_names
data <- data[, -1]  


zip_probs <- read.table(zip_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zip_probs) <- zip_probs$TrueID
zip_probs <- zip_probs[, -1]  # Remove the TrueID column

zip_probs <- zip_probs[rownames(data), colnames(data)]  # Align dimensions

adjusted_data <- data

for (i in 1:nrow(data)) {
  for (j in 1:ncol(data)) {
    if (data[i, j] == 0) {
      # Use the ZIP probability to adjust zero values
      prob <- zip_probs[i, j]
      if (!is.na(prob)) {
        adjusted_data[i, j] <- (1 - prob) * 0.01  # Scale near-zero values for technical zeros
      }
    }
  }
}



adjusted_data <- log(adjusted_data + 1)

# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(adjusted_data)
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


write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)