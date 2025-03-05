
library(pscl)      
library(reshape2)   


# input_file <- "test_files/rewritten_test_kraken1.tsv"
# output_file_zip <- "test_files/zip_probabilities.tsv"
# output_file_zinb <- "test_files/zinb_probabilities.tsv"

# input_file = "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv" 
# output_file_zip <- "/storage/bergid/zero_inflations/zip_probabilities_ww.tsv"
# output_file_zinb <- "/storage/bergid/zero_inflations/zip_probabilities_ww.tsv"

input_file = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
output_file_zip <- "/storage/bergid/zero_inflations/zip_probabilities_hg.tsv"
output_file_zinb <- "/storage/bergid/zero_inflations/zip_probabilities_hg.tsv"


data <- read.table(input_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)


tax_ids <- data$TrueID
rownames(data) <- tax_ids
count_data <- data[, -1]  # Exclude the first column (TaxID)

# Prepare output matrices for probabilities
zip_probabilities <- count_data  # Will store ZIP probabilities
zinb_probabilities <- count_data  # Will store ZINB probabilities

# Loop through each row (organism) in the dataset
for (i in 1:nrow(count_data)) {
  # Extract counts for the current row
  counts <- as.numeric(count_data[i, ])
  tax_id <- tax_ids[i]

  # Skip rows with all zeros (models won't work on zero-only data)
  if (all(counts == 0)) {
    zip_probabilities[i, ] <- NA  # Assign NA for rows with all zeros
    zinb_probabilities[i, ] <- NA
    next
  }

  # Create a data frame for the current organism
  row_df <- data.frame(Sample = colnames(count_data), Counts = counts)

  # Fit ZIP model
  zip_model <- tryCatch(
    zeroinfl(Counts ~ 1 | 1, data = row_df, dist = "poisson"),
    error = function(e) NULL # skip the rows without zeros
  )

  # Fit ZINB model
  zinb_model <- tryCatch(
    zeroinfl(Counts ~ 1 | 1, data = row_df, dist = "negbin"),
    error = function(e) NULL
  )

  # Predict zero-inflation probabilities
  if (!is.null(zip_model)) {
    zip_probs <- predict(zip_model, type = "zero")
    zip_probabilities[i, ] <- ifelse(counts == 0, zip_probs, 0)  # Only assign probabilities to zeros
  } else {
    zip_probabilities[i, ] <- NA
  }

  if (!is.null(zinb_model)) {
    zinb_probs <- predict(zinb_model, type = "zero")
    zinb_probabilities[i, ] <- ifelse(counts == 0, zinb_probs, 0)  # Only assign probabilities to zeros
  } else {
    zinb_probabilities[i, ] <- NA
  }
}

# Combine ZIP probabilities with TaxID for output
zip_output <- cbind(TrueID = tax_ids, zip_probabilities)
zinb_output <- cbind(TrueID = tax_ids, zinb_probabilities)

# Write the ZIP model probabilities to a file
write.table(zip_output, file = output_file_zip, sep = "\t", quote = FALSE, row.names = FALSE)

# Write the ZINB model probabilities to a file
write.table(zinb_output, file = output_file_zinb, sep = "\t", quote = FALSE, row.names = FALSE)

