# ------------------------------------------------------------------------
# Calculate the correlation between organisms using zero inflation as weights 
# ------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)
library(pbapply)

count_matrix <- "/storage/koningen/count_matrix_filtered.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_weighted_apply.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data$GeneNames
rownames(data) <- gene_names


data <- data[, -1] 


data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))




zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$GeneNames
zinb_probs <- zinb_probs[, -1]   


weight_matrix <- matrix(0, nrow = nrow(data_mat), ncol = ncol(data_mat),
                        dimnames = list(rownames(data_mat), colnames(data_mat)))

weight_matrix[data_mat != 0] <- 1  # Where data is non-zero, weight is 1
weight_matrix[data_mat == 0] <- (1 - as.matrix(zinb_probs)[data_mat == 0]) * 0.01
weight_matrix[as.matrix(zinb_probs) == 1 & data_mat == 0] <- 10^(-15)


weighted_correlation <- function(x, y, weight_x, weight_y) {
  mean_x <- sum(weight_x * x) / sum(weight_x)
  mean_y <- sum(weight_y * y) / sum(weight_y)

  cov <- (weight_x * (x - mean_x) * weight_y * (y - mean_y))
  var_x <- (weight_x * (x - mean_x))^2
  var_y <- (weight_y * (y - mean_y))^2
    
  weighted_correlation_coefficient <- sum(cov) / sqrt(sum(var_x) * sum(var_y))
  return(weighted_correlation_coefficient)
}


vectorized_correlation <- Vectorize(function(i, j) {
  x <- data_mat[i, ]
  y <- data_mat[j, ]
  weight_x <- weight_matrix[i, ]
  weight_y <- weight_matrix[j, ]
  
  weighted_correlation(x, y, weight_x, weight_y)
})

indices <- expand.grid(1:nrow(data_mat), 1:nrow(data_mat))

correlation_coefficient <- matrix(
  mapply(function(i, j) {
    cat(sprintf("Calculating row %d and row %d\n", i, j))
    vectorized_correlation(i, j)
  }, indices[, 1], indices[, 2]),
  nrow = nrow(data),
  ncol = nrow(data),
  dimnames = list(rownames(data_mat), rownames(data_mat)) 
)

cor_long <- melt(correlation_coefficient, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")
write.table(cor_long, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
