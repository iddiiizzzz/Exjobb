# ------------------------------------------------------------------------------
# Calculate the correlation between genes usning zero inflations as probability
# ------------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)
library(tictoc) 

count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms_filtered.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zinb_probabilities_all_organisms.tsv"
results <- "/storage/bergid/correlation/organisms/org_correlation_zero_inflation_probabilities.tsv"

tic()
cat("read data \n")
data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(data) <- data$TrueID
data <- data[, -1]  

data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))



zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$TrueID
zinb_probs <- zinb_probs[, -1]  
toc()

r <- matrix(runif(length(data_mat)),ncol=ncol(data_mat))
new_data<-data_mat

print(dim(new_data))
print(dim(zinb_probs))
new_data[new_data == 0 & zinb_probs<r]<-NA

cat("corr\n")
tic()
result <- rcorr(t(new_data), type = "pearson")
corr_result <- result$r
p_matrix  <- result$P
toc()   

cat("melt 1\n")
tic()
cor_long <- melt(corr_result, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
toc()
cat("melt 2\n")
tic()
p_long   <- melt(p_matrix,   varnames = c("Organism1", "Organism2"), value.name = "pValue")
toc()

cat("merge\n")
tic()
result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))
toc()

cat("write\n")
tic()
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
toc()
