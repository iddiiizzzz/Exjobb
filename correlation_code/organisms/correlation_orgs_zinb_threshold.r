# ------------------------------------------------------------------------------
# Calculate the correlation between genes using zero inflation with threshold
# ------------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)   

count_matrix <- "/storage/koningen/count_matrix.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_threshold.tsv" # 90%

# count_matrix <- "test_files/test_gene_count_matrix.tsv"
# zinb_prob_file <- "test_files/zinb_probabilities.tsv"
# results <- "test_files/correlation_zinb_threshold_test.tsv"



data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$TrueID
rownames(data) <- org_names


data <- data[, -1]  
data <- data[(rowSums(data == 0) / ncol(data)) < 0.90, ]
data <- log(data + 1)

# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))




zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$GeneNames
zinb_probs <- zinb_probs[, -1]  

threshold = 0.5
corr_result <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))
p_matrix <- matrix(NA, nrow = nrow(data_mat), ncol = nrow(data_mat),
                              dimnames = list(rownames(data_mat), rownames(data_mat)))

for (i in 1:nrow(data_mat)) {
    print(i)
    for (j in 1:nrow(data_mat)) {
        temp_data <- t(cbind(data_mat[i, ], data_mat[j, ]))

        new_temp_data <- matrix(NA, nrow = 2, ncol = ncol(data_mat))



        prob1 = zinb_probs[i,] 
        prob2 = zinb_probs[j,]

        true_zeros1 = (prob1 > threshold) # true or false vector
        true_zeros2 = (prob2 > threshold) # true = true zero

        double_zero =  colSums(temp_data == 0) == 2
        one_true_zero = true_zeros1 | true_zeros2 # checks if at least one of them is true

        filtered_matrix =  !(double_zero & !one_true_zero) # removes if both double zero and both FALSE
        new_temp_data <- temp_data[, filtered_matrix, drop = FALSE]


        result <- rcorr(t(new_temp_data), type = "pearson")
        corr_result[i, j] <- result$r[1,2] 
        p_matrix[i,j]   <- result$P[1,2]
        
        

        
    }
}



cor_long <- melt(corr_result, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Organism1", "Organism2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))



write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)