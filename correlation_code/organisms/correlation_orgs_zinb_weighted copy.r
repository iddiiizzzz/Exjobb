# ------------------------------------------------------------------------
# Calculate the correlation between genes using zero inflation as weights
# ------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)   

count_matrix <- "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"
zinb_prob_file <- "/storage/koningen/zero_inflations/zinb_probabilities_all_organisms.tsv"
results <- "/storage/bergid/correlation/genes/orgs_correlation_zero_inflation_weighted.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$TrueID
rownames(data) <- org_names


data <- data[, -1]  
data <- data[(rowSums(data == 0) / ncol(data)) < 0.90, ]
data <- log(data + 1)

data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))




zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$TrueID
zinb_probs <- zinb_probs[, -1]  

weight_matrix <- matrix(NA, nrow = nrow(data), ncol = ncol(data),
                              dimnames = list(rownames(data), colnames(data)))


for (i in 1:nrow(data)) {
  cat("first loop\n")
  print(i)

  for (j in 1:ncol(data)) {
    if (data[i,j] != 0) {
      weight_matrix[i,j] <- 1
      

    } else {
      
      prob <- zinb_probs[i, j]
      

      if (prob != 1){
        weight_matrix[i, j] <- (1 - prob) * 0.01  # Scale near-zero values for technical zeros
        
      } else {
        weight_matrix[i, j] <- 10^(-15)
      
      }
    }
  }
}



weighted_correlation <- function(x, y, weight_x, weight_y) {


  mean_x <- sum(weight_x * x)/sum(weight_x)
  mean_y <- sum(weight_y * y)/sum(weight_y)

  cov <- (weight_x * (x - mean_x) * weight_y * (y - mean_y))

  var_x <- (weight_x * (x - mean_x))^2
  var_y <- (weight_y * (y - mean_y))^2
    

  weighted_correlation_coefficient <- sum(cov)/sqrt(sum(var_x) * sum(var_y))
  

  return(weighted_correlation_coefficient)

}


correlation_coefficient <- matrix(NA, nrow = nrow(data), ncol = nrow(data),
                              dimnames = list(rownames(data), rownames(data)))


########### mapply 
vectorized_correlation <- Vectorize(function(i, j) {
  x <- as.numeric(data[i, ])
  y <- as.numeric(data[j, ])
  weight_x <- as.numeric(weight_matrix[i, ])
  weight_y <- as.numeric(weight_matrix[j, ])
  
  weighted_correlation(x, y, weight_x, weight_y)
})

indices <- expand.grid(1:nrow(data), 1:nrow(data)) # Generate row and column indices for all pairwise combinations

# Apply the function to all row combinations
correlation_coefficient <- matrix(
  mapply(vectorized_correlation, indices[, 1], indices[, 2]),
  nrow = nrow(data),
  ncol = nrow(data)
)





cor_long <- melt(correlation_coefficient, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")


write.table(cor_long, file = results, sep = "\t", quote = FALSE, row.names = FALSE)