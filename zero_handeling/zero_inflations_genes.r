
library(pscl)      
library(reshape2)   

##test
# input_file <- "test_files/final_count_matrix_genes.tsv"
# output_file_zinb <- "test_files/zinb_genes.tsv"

##all
# input_file <- "/storage/koningen/species/taxonomy_code/final_count_matrix_genes.tsv"
# output_file_zinb <- "/storage/koningen/species/zero_inflations/zero_inflations_genes.tsv"




data <- read.table(input_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)


gene_names <- data$GeneNames
rownames(data) <- gene_names
data <- data[, -1]  # Exclude the first column (TaxID)


# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))


zinb_probabilities <-  matrix(NA, nrow = nrow(data_mat), ncol = ncol(data_mat),
                              dimnames = list(rownames(data_mat), colnames(data_mat)))  # Will store ZINB probabilities

for (i in 1:nrow(data_mat)) {
  print(i)
  
  counts <- as.numeric(data_mat[i, ])
  

  # Skip rows with all zeros (models won't work on zero-only data)
  if (all(counts == 0)) {
    zinb_probabilities[i, ] <- 1
    next
  }

  row_df <- data.frame(Sample = colnames(data_mat), Counts = counts)

  zinb_model <- tryCatch(
    zeroinfl(Counts ~ 1 | 1, data = row_df, dist = "negbin"),
    error = function(e) NULL
  )


  if (!is.null(zinb_model)) {
    zinb_probs <- predict(zinb_model, type = "zero")
    zinb_probabilities[i, ] <- ifelse(counts == 0, zinb_probs, 0)  # Only assign probabilities to zeros
  } else {
    zinb_probabilities[i, ] <- 0
  }
}

zinb_output <- cbind(GeneNames = rownames(zinb_probabilities), zinb_probabilities)
write.table(zinb_output, file = output_file_zinb, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

