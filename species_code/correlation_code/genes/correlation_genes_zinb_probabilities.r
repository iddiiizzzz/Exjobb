# ------------------------------------------------------------------------------
# Calculate the correlation between genes usning zero inflations as probability
# ------------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)   

count_matrix <- "/storage/koningen/count_matrix_filtered.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_probabilities.tsv" #tmux ida correlation_2


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(data) <- data$GeneNames
data <- data[, -1]  



data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))



zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$GeneNames
zinb_probs <- zinb_probs[, -1]  

r <- matrix(runif(length(data_mat)),ncol=ncol(data_mat))
new_data <- data_mat

print(dim(new_data))
print(dim(zinb_probs))
new_data[new_data == 0 & zinb_probs > r]<-NA


result <- rcorr(t(new_data), type = "pearson")
corr_result <- result$r
p_matrix  <- result$P
        

cor_long <- melt(corr_result, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Gene1", "Gene2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Gene1", "Gene2"))



write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
