# ------------------------------------------------------------------------------
# Calculate the correlation between genes usning zero inflations as probability
# ------------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)   

count_matrix <- "/storage/koningen/count_matrix.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_probabilities.tsv"


# count_matrix <- "test_files/test_gene_count_matrix.tsv"
# zinb_prob_file <- "test_files/zinb_probabilities.tsv"
# results <- "test_files/correlation_zinb_probabilities_utannollrad.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data$GeneNames
rownames(data) <- gene_names
data <- data[, -1]  
data <- log(data + 1)

data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))




zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$GeneNames
zinb_probs <- zinb_probs[, -1]  



corr_result <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))
p_matrix <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))

for (i in 1:nrow(data_mat)) {
    print(i)
    for (j in 1:nrow(data_mat)) {
        temp_data <- t(cbind(data_mat[i, ], data_mat[j, ]))
        

        new_temp_data <- matrix(NA, nrow = 2, ncol = ncol(data_mat))

        for (k in 1:ncol(temp_data)) {
            r1 = runif(1)
            r2 = runif(1)
            
            if (all(temp_data[,k] == 0)){
                
                prob1 = zinb_probs[i,k]
                prob2 = zinb_probs[j,k]
                print(prob1)
                print(prob2)

                if (prob1 < r1 && prob2 < r2) {
                    next
                }
                else {
                    new_temp_data[,k] <- temp_data[, k]
                    
                }

            }
            new_temp_data[,k] <- temp_data[, k]

        }

        result <- rcorr(t(new_temp_data), type = "pearson")
        corr_result[i, j] <- result$r[1,2] 
        p_matrix[i,j]   <- result$P[1,2]
        
        

        
    }
}



cor_long <- melt(corr_result, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Gene1", "Gene2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Gene1", "Gene2"))



write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)