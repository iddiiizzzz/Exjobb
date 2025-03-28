
# Organisms
# count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv"
# results <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms_filtered.tsv"

count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
results <- "/storage/bergid/taxonomy_rewrites/taxonomy_hg_organisms_filtered.tsv"


# Genes
# count_matrix <- "/storage/koningen/count_matrix.tsv"
# results <- "/storage/koningen/count_matrix_filtered.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$TrueID
# org_names <- data$GeneNames
rownames(data) <- org_names

print(dim(data))
data <- data[, -1]  
data <- data[(rowSums(data == 0) / ncol(data)) < 0.90, ]
data <- log(data + 1)
print(dim(data))
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

print(dim(data_mat))

data_mat_df <- data.frame(TrueID = rownames(data_mat), data_mat, check.names = FALSE)
# data_mat_df <- data.frame(GeneNames = rownames(data_mat), data_mat, check.names = FALSE)
write.table(data_mat_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
