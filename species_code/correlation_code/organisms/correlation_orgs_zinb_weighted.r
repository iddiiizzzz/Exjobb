# ------------------------------------------------------------------------
# Calculate the correlation between organisms using zero inflation as weights
# ------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)
library(pbapply)

count_matrix <- "/storage/koningen/final_count_matrix_orgs.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zinb_probabilities_orgs.tsv"
results <- "/storage/bergid/correlation/genes/orgs_correlation_zero_inflation_weighted.tsv"

data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$OrgNames
rownames(data) <- org_names
data <- data[, -1]  


data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

cat("reading data done\n")

zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$OrgNames
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

cat("weighting done\n")
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
cat("correlation done\n")
cor_long <- melt(correlation_coefficient, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")

cat("writing\n")
write.table(cor_long, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
