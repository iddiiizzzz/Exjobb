# ------------------------------------------------------------------------
# Calculate the correlation between genes using zero inflation as weights
# ------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)   

# count_matrix <- "/storage/koningen/count_matrix.tsv"
# zinb_prob_file <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
# results <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_weighted.tsv"

count_matrix <- "test_files/test_gene_count_matrix.tsv"
zinb_prob_file <- "test_files/zinb_probabilities.tsv"
results <- "test_files/correlation_zinb_weigths_test.tsv"


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




zinb_probs <- read.table(zinb_prob_file, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
rownames(zinb_probs) <- zinb_probs$TrueID
zinb_probs <- zinb_probs[, -1]  

weight_matrix <- matrix(NA, nrow = nrow(data), ncol = ncol(data),
                              dimnames = list(rownames(data), colnames(data)))


for (i in 1:nrow(data)) {
  cat("hey")
  print(i)
  for (j in 1:ncol(data)) {
    if (data[i,j] != 0) {
      weight_matrix[i,j] <- 1
      cat("ej noll \n")

    } else {
      
      prob <- zinb_probs[i, j]
      cat("noll\n")
      print(prob)

      if (prob != 1){
        weight_matrix[i, j] <- (1 - prob) * 0.01  # Scale near-zero values for technical zeros
        cat("weight\n")
      } else {
        weight_matrix[i, j] <- 10^(-15)
      
      }
    }
  }
}



weighted_correlation <- function(x, y, weight_x, weight_y) {


  mean_x <- sum(weight_x * x)/sum(weight_x)
  mean_y <- sum(weight_y * y)/sum(weight_y)



  cov <- numeric(length(x))
  var_x <- numeric(length(x))
  var_y <- numeric(length(x))


  for (i in 1:2) {
    
    cov[i] <- (weight_x[i] * (x[i] - mean_x) * weight_y[i] * (y[i] - mean_y))

    var_x[i] <- weight_x[i] * (x[i] - mean_x)^2
    var_y[i] <- weight_y[i] * (y[i] - mean_y)^2
    

  }
 


  weighted_correlation_coefficient <- sum(cov)/sqrt(sum(var_x) * sum(var_y))
  

  return(weighted_correlation_coefficient)

}


correlation_coefficient <- matrix(NA, nrow = nrow(data), ncol = nrow(data),
                              dimnames = list(rownames(data), rownames(data)))


for (i in 1:nrow(data)) {
  cat("hello\n")
  print(i)
  for (j in 1:nrow(data)) { 
    cat("hi\n")

    x <-  as.numeric(data[i, ])
    y <- as.numeric(data[j, ])
    weight_x <- as.numeric(weight_matrix[i, ])
    weight_y <- as.numeric(weight_matrix[j, ])


    correlation_coefficient[i,j] <- weighted_correlation(x, y, weight_x, weight_y)
  }
}




cor_long <- melt(correlation_coefficient, varnames = c("Gene1", "Gene2"), value.name = "CorrelationCoefficient")


write.table(cor_long, file = results, sep = "\t", quote = FALSE, row.names = FALSE)