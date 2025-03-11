# -------------------------------------------------
# Calculate the correlation between orgnanisms, zero inflation
#   one file at a time
# -------------------------------------------------

library(Hmisc)      
library(reshape2)   

# count_matrix <- "/storage/koningen/count_matrix.tsv"
# zip_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
# results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_weighted.tsv"

count_matrix <- "test_files/test_double_zeros.tsv"
zinb_prob_file <- "test_files/zinb_probabilities.tsv"
results <- "test_files/correlation_zinb_weighted_test.tsv"



data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data$GeneNames
rownames(data) <- gene_names
data <- data[, -1]  
data <- log(data + 1)

# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))




zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$TrueID
zinb_probs <- zinb_probs[, -1]  

threshold = 0.5
corr_result <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))

for (i in 1:nrow(data_mat)) {
    for (j in 1:nrow(data_mat)) {
        temp_data <- cbind(data_mat[i, ], data_mat[j, ])

        if (temp_data[,1] == 0 & temp_data[,2] == 0){
            prob1 = zinb_probs[i, ]
            prob2 = zinb_probs[j,]

            if (prob1 < threshold & prob2 < threshold) {
                break
            }
            else {
                corr_result <- rcorr(temp_data, type = "pearson")
            }
        }
        else {
            corr_result <- rcorr(temp_data, type = "pearson")
        }

        
    }
}

cor_matrix <- corr_result$r
p_matrix   <- corr_result$P

rownames(cor_matrix) <- rownames(data)
colnames(cor_matrix) <- rownames(data)
rownames(p_matrix)   <- rownames(data)
colnames(p_matrix)   <- rownames(data)

cor_long <- melt(cor_matrix, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Gene1", "Gene2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Gene1", "Gene2"))



write.table(cor_long, file = results, sep = "\t", quote = FALSE, row.names = FALSE)