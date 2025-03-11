
library(pscl)      
library(reshape2)   


# input_file <- "test_files/test_double_zeros.tsv"
# output_file_zinb <- "test_files/zinb_probabilities.tsv"

# input_file = "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv" 
# output_file_zinb <- "/storage/bergid/zero_inflations/zip_probabilities_ww.tsv"

# input_file = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# output_file_zinb <- "/storage/bergid/zero_inflations/zip_probabilities_hg.tsv"



data <- read.table(input_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)


tax_ids <- data$TrueID
rownames(data) <- tax_ids
count_data <- data[, -1]  # Exclude the first column (TaxID)

# Prepare output matrices for probabilities
zinb_probabilities <- count_data  # Will store ZINB probabilities

for (i in 1:nrow(count_data)) {
  counts <- as.numeric(count_data[i, ])
  tax_id <- tax_ids[i]

  # Skip rows with all zeros (models won't work on zero-only data)
  if (all(counts == 0)) {
    zinb_probabilities[i, ] <- NA
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
    zinb_probabilities[i, ] <- NA
  }
}

zinb_output <- cbind(TrueID = tax_ids, zinb_probabilities)
write.table(zinb_output, file = output_file_zinb, sep = "\t", quote = FALSE, row.names = FALSE)

