# ------------------------------------------------------------------------------
# Calculate the correlation between genes compairing zero inflations to a threshold
# ------------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)   

count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms_filtered.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zinb_probabilities_orgs.tsv"
results <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_09.tsv"


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

threshold = 0.9
new_data <- data_mat

print(dim(new_data))
print(dim(zinb_probs))
new_data[new_data == 0 & zinb_probs > threshold] <- NA


result <- rcorr(t(new_data), type = "pearson")
corr_result <- result$r
p_matrix  <- result$P
        
cat("correlation done\n")
cor_long <- melt(corr_result, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Organism1", "Organism2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))


cat("writing\n")
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
