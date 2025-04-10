# ------------------------------------------------------------------------------
# Calculate the correlation between genes usning zero inflations as probability
# ------------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)
library(tictoc) 

count_matrix <- "/storage/koningen/final_count_matrix_orgs.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zinb_probabilities_orgs.tsv"
results <- "/storage/bergid/correlation/organisms/org_correlation_zero_inflation_probabilities.tsv"

data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(data) <- data$OrgNames
data <- data[, -1]  

data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

cat("reading data done\n")

zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$OrgNames
zinb_probs <- zinb_probs[, -1]  

r <- matrix(runif(length(data_mat)),ncol=ncol(data_mat))
new_data <- data_mat
new_data[new_data == 0 & zinb_probs > r] <- NA

result <- rcorr(t(new_data), type = "pearson")
corr_result <- result$r
p_matrix  <- result$P
cat("correlation done\n")
cor_long <- melt(corr_result, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Organism1", "Organism2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))
cat("writing\n")
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)

