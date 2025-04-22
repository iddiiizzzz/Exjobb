
library(pscl)      
library(reshape2)   

# input_file = "test_files/final_count_matrix_orgs.tsv"
# output_file_zinb <- "test_files/zinb_orgs.tsv"

### Normalized
## all
input_file = "/storage/koningen/species/normalize/normalized_count_matrix_all_orgs.tsv"
output_file_zinb = "/storage/koningen/species/zero_inflations/normalized_zinb_matrix_all_orgs.tsv"

## hg
# input_file = "/storage/koningen/species/normalize/normalized_count_matrix_hg.tsv"
# output_file_zinb = "/storage/koningen/species/zero_inflations/normalized_zinb_matrix_hg.tsv"

## ww
# input_file = "/storage/koningen/species/normalize/normalized_count_matrix_ww.tsv"
# output_file_zinb = "/storage/koningen/species/zero_inflations/normalized_zinb_matrix_ww.tsv" 



### Non-normalized
## all
# input_file = "/storage/koningen/species/combined_matrices/taxonomy_all_organisms.tsv"
# output_file_zinb = "/storage/koningen/species/zero_inflations/zinb_matrix_all_orgs.tsv" 

# ## ww
# input_file =  "/storage/koningen/species/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
# output_file_zinb = "/storage/koningen/species/zero_inflations/zinb_matrix_ww.tsv" 

## hg
# input_file =  "/storage/koningen/species/filter_zeros/taxonomy_hg_organisms_filtered.tsv"
# output_file_zinb = "/storage/koningen/species/zero_inflations/zinb_matrix_hg.tsv" 



data <- read.table(input_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")


tax_ids <- data$OrgNames
rownames(data) <- tax_ids
data <- data[, -1]  # Exclude the first column (TaxID)


# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))


zinb_probabilities <-  matrix(NA, nrow = nrow(data_mat), ncol = ncol(data_mat),
                              dimnames = list(rownames(data_mat), colnames(data_mat)))  # store ZINB probabilities
