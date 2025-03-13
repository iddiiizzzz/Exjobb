
library(pscl)      
library(reshape2)   



# input_file <- "/storage/koningen/count_matrix.tsv"
# output_file_zinb <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
input_file <- "test_files/test_gene_count_matrix.tsv"
output_file_zinb <- "test_files/zinb_probabilities.tsv"

data <- read.table(input_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)


gene_names <- data$GeneNames
rownames(data) <- gene_names
count_data <- data[, -1]  # Exclude the first column (TaxID)

zinb_probabilities <- count_data  # Will store ZINB probabilities

for (i in 1:nrow(count_data)) {
  counts <- as.numeric(count_data[i, ])
  print(i)

  # Skip rows with all zeros (models won't work on zero-only data)
  if (all(counts == 0)) {
    zinb_probabilities[i, ] <- 1
    next
  }

  row_df <- data.frame(Sample = colnames(count_data), Counts = counts)

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

zinb_output <- cbind(GeneNames = gene_names, zinb_probabilities)
write.table(zinb_output, file = output_file_zinb, sep = "\t", quote = FALSE, row.names = FALSE)

