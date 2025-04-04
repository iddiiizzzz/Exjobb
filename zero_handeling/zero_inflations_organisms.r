
library(pscl)      
library(reshape2)   


input_file = "test_files/final_count_matrix_orgs.tsv"
output_file_zinb <- "test_files/zinb_orgs.tsv"


# input_file = "/storage/koningen/final_count_matrix_orgs.tsv"
# output_file_zinb <- "/storage/koningen/zero_inflations/zinb_probabilities_orgs.tsv" 

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

for (i in 1:nrow(data)) {
  print(i)
  counts <- as.numeric(data[i, ])

  # Skip rows with all zeros (models won't work on zero-only data)
  if (all(counts == 0)) {
    zinb_probabilities[i, ] <- 1
    next
  }

  row_df <- data.frame(Sample = colnames(data), Counts = counts)

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


zinb_output <- cbind(OrgNames = rownames(zinb_probabilities), zinb_probabilities)
write.table(zinb_output, file = output_file_zinb, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
