
# ------------------------------------------------------------------------------------------------------------

# Filters the count matrices to remove genes or organisms with at least 90% zero counts. 
# Transforms the data logarithmically.

# Input:
#     - count_matrix: Path to the count matrix file.

# Output:
#     - results: Path to the output file that stores filtered count matrix.

# Notes:
#     - Switch the out commented files and rows depending on which matrix to filter and transform.
#     - Switch the out commented lines depening on if it is genes or organisms

# ------------------------------------------------------------------------------------------------------------


# Species organisms
# count_matrix <- "/storage/koningen/species/combined_matrices/taxonomy_all_ww_organisms.tsv"
# results <- "/storage/koningen/species/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"

count_matrix <- "/storage/koningen/species/matching_samples/matching_count_matrix_orgs_hg.tsv"
results <- "/storage/koningen/species/filter_zeros/taxonomy_hg_organisms_filtered.tsv"


# Species genes
# count_matrix <- "/storage/koningen/species/combined_matrices/taxonomy_all_ww_organisms_genes.tsv"
# results <- "/storage/koningen/species/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"

# count_matrix <- "/storage/koningen/species/matching_samples/matching_count_matrix_genes_hg.tsv"
# results <- "/storage/koningen/species/filter_zeros/taxonomy_hg_genes_filtered.tsv"



# Genus organisms
# count_matrix <- "/storage/koningen/genus/combined_matrices/taxonomy_all_ww_organisms.tsv"
# results <- "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"

# count_matrix <- "/storage/koningen/genus/matching_samples/matching_count_matrix_orgs_hg.tsv"
# results <- "/storage/koningen/genus/filter_zeros/taxonomy_hg_organisms_filtered.tsv"


# Genus genes
# count_matrix <- "/storage/koningen/genus/combined_matrices/taxonomy_all_ww_genes.tsv"
# results <- "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"

# count_matrix <- "/storage/koningen/genus/matching_samples/matching_count_matrix_genes_hg.tsv"
# results <- "/storage/koningen/genus/filter_zeros/taxonomy_hg_genes_filtered.tsv"




data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = TRUE)
org_names <- data$OrgNames
# org_names <- data$GeneNames
rownames(data) <- org_names

data <- data[, -1]  
data <- data[(rowSums(data == 0) / ncol(data)) < 0.90, ]


data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

data_mat_df <- data.frame(OrgNames = rownames(data_mat), data_mat, check.names = FALSE)
# data_mat_df <- data.frame(GeneNames = rownames(data_mat), data_mat, check.names = FALSE)
write.table(data_mat_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
