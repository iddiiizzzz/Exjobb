# -------------------------------------------------
# Calculate the correlation between orgnanisms, zero inflation
#   one file at a time
# -------------------------------------------------

library(Hmisc)      
library(reshape2)   

count_matrix <- "/storage/koningen/count_matrix.tsv"
zip_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_weighted.tsv"



data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data$GeneNames
rownames(data) <- gene_names
data <- data[, -1]  


data <- log(data + 1)

# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))




zip_probs <- read.table(zip_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zip_probs) <- zip_probs$TrueID
zip_probs <- zip_probs[, -1]  

weight_matrix <- matrix(NA, nrow = nrow(data), ncol = ncol(data),
                              dimnames = list(rownames(data), colnames(data)))


for (i in 1:nrow(data)) {
  for (j in 1:ncol(data)) {
    if (data[i,j] != 0) {
      weight_matrix[i,j] <- 1
    }

    if (data[i, j] == 0) {
      
      prob <- zip_probs[i, j]
      print(prob)
      weight_matrix[i, j] <- (1 - prob) * 0.01  # Scale near-zero values for technical zeros

    
    }
  }
}
print(weight_matrix)



weighted_correlation <- function(x, y, weight_x, weight_y) {
  mean_x <- sum(weight_x * x)
  mean_y <- sum(weight_y * y)

  numerator <- sum(weight_x * (x - mean_x) * weight_y * (y - mean_y))

  root_x <- sqrt(sum(weight_x * (x - mean_x)^2))
  root_y <- sqrt(sum(weight_y * (y - mean_y)^2))
   
  
  denominator <- root_x * root_y

  weighted_correlation_coefficient <- numerator/denominator

  return(weighted_correlation_coefficient)

}


correlation_coefficient <- matrix(NA, nrow = nrow(data), ncol = nrow(data),
                              dimnames = list(rownames(data), rownames(data)))

for (i in 1:nrow(data)) {
  for (j in 1:nrow(data)) {
    x <-data_mat[i, ]
    y <-data_mat[j, ]
    weight_x <- weight_matrix[i, ]
    weight_y <- weight_matrix[j, ]

    correlation_coefficient[i,j] <- weighted_correlation(x, y, weight_x, weight_y)
  }
}




cor_long <- melt(correlation_coefficient, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")


write.table(cor_long, file = results, sep = "\t", quote = FALSE, row.names = FALSE)