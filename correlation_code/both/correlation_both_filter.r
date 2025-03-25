
# -------------------------------------------------
# Calculate the correlation between genes, filter 75% zeros, 
# NOT UPDATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   


# count_matrix_genes = "/storage/koningen/filtered_count_matrix.tsv"
# count_matrix_orgs = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms_filtered.tsv"
# results = "/storage/bergid/correlation/both/correlation_filtered.tsv"

count_matrix_genes = "blast_code/blast_outputs/filtered_count_matrix.tsv"
count_matrix_orgs = "/home/bergid/Exjobb/test_files/rewritten_test_kraken1.tsv"
results = "test_files/correlation_both.tsv"


data_gene <- read.table(count_matrix_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data_gene$GeneNames
rownames(data_gene) <- gene_names
data_gene <- data_gene[, -1]  

data_mat_gene <- as.matrix(data_gene)
data_mat_gene <- matrix(as.numeric(data_mat_gene), 
                   nrow = nrow(data_mat_gene), 
                   ncol = ncol(data_mat_gene),
                   dimnames = list(rownames(data_gene), colnames(data_gene)))


data_org <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data_org$TrueID
rownames(data_org) <- org_names
data_org <- data_org[, -1]  

data_mat_org <- as.matrix(data_org)
data_mat_org <- matrix(as.numeric(data_mat_org), 
                   nrow = nrow(data_mat_org), 
                   ncol = ncol(data_mat_org),
                   dimnames = list(rownames(data_org), colnames(data_org)))



res <- rcorr(t(data_mat_gene), t(data_mat_org), type = "pearson") 


cor_matrix <- res$r
p_matrix   <- res$P

rownames(cor_matrix) <- rownames(data_gene)
colnames(cor_matrix) <- rownames(data_org)
rownames(p_matrix)   <- rownames(data_gene)
colnames(p_matrix)   <- rownames(data_org)

cor_long <- melt(cor_matrix, varnames = c("Gene", "Organism"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Gene", "Organism"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Gene", "Organism"))



# # Function to calculate the percentage of zero-pairs
# calculate_zero_percentage <- function(mat) {
#   n <- ncol(mat)  # Number of samples/columns
#   zero_percentage_matrix <- matrix(0, nrow = nrow(mat), ncol = nrow(mat), 
#                                    dimnames = list(rownames(mat), rownames(mat)))
  
#   for (i in 1:nrow(mat)) {
#     for (j in 1:nrow(mat)) {
#       zero_count <- sum(mat[i, ] == 0 & mat[j, ] == 0)  # Count when both zero
#       zero_percentage_matrix[i, j] <- (zero_count / n) * 100  # Percentage
#     }
#   }
#   return(zero_percentage_matrix)
# }

# zero_percentage_matrix <- calculate_zero_percentage(data_mat)
# zero_long <- melt(zero_percentage_matrix, varnames = c("Gene", "Organism"), value.name = "DoubleZeroPercentage") # Long format
# result_df <- merge(result_df, zero_long, by = c("Gene", "Organism")) # Merge correlation and p-values

# Save the updated results
write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

