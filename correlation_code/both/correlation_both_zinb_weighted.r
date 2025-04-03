# ------------------------------------------------------------------------
# Calculate the correlation between organisms and genes using zero inflation as weights
# ------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)
library(pbapply)

# count_matrix_genes = "test_files/matching_samples_genes.tsv"
# count_matrix_orgs = "test_files/matching_samples_orgs.tsv"
# results = "test_files/correlation_both_test.tsv"
# blast_results = "test_files/blast_with_true_names_fixed.txt"
# zinb_genes <- "test_files/zinb_probabilities_genes.tsv"
# zinb_orgs <- "test_files/zinb_probabilities_orgs.tsv"

count_matrix_genes = "/storage/koningen/final_count_matrix_genes.tsv"
count_matrix_orgs = "/storage/koningen/final_count_matrix_orgs.tsv"

blast_results = "/storage/bergid/blast/blast_final.txt"

zinb_genes <- "/storage/koningen/zero_inflations/zero_inflations_genes.tsv"
zinb_orgs <- "/storage/koningen/zero_inflations/zinb_probabilities_orgs.tsv"

results = "/storage/bergid/correlation/both/correlation_zinb_weighted.tsv"


# Read files
blast_table <- read.table(blast_results, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")

data_gene <- read.table(count_matrix_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")
gene_names <- data_gene$GeneNames
rownames(data_gene) <- gene_names
data_gene <- data_gene[, -1]  

data_org <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")
org_names <- data_org$OrgNames
rownames(data_org) <- org_names
data_org <- data_org[, -1]  

# Convert to matrices
data_mat_genes <- as.matrix(data_gene)
data_mat_genes <- matrix(as.numeric(data_mat_genes), 
                   nrow = nrow(data_mat_genes), 
                   ncol = ncol(data_mat_genes),
                   dimnames = list(rownames(data_gene), colnames(data_gene)))


data_mat_orgs <- as.matrix(data_org)
data_mat_orgs <- matrix(as.numeric(data_mat_orgs), 
                   nrow = nrow(data_mat_orgs), 
                   ncol = ncol(data_mat_orgs),
                   dimnames = list(rownames(data_org), colnames(data_org)))


cat("All files read\n")


# Extract gene and organims names
blast_gene_names <- blast_table$qseqid
blast_org_names <- blast_table$Org_names


# Read zero inflation files
zinb_probs_genes <- read.table(zinb_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")
rownames(zinb_probs_genes) <- zinb_probs_genes$GeneNames
zinb_probs_genes <- zinb_probs_genes[, -1]  

zinb_probs_orgs <- read.table(zinb_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")
rownames(zinb_probs_orgs) <- zinb_probs_orgs$OrgNames
zinb_probs_orgs <- zinb_probs_orgs[, -1]  


# Create weight matrices
cat("weight\n")
weight_matrix_genes <- matrix(0, nrow = nrow(data_mat_genes), ncol = ncol(data_mat_genes),
                        dimnames = list(rownames(data_mat_genes), colnames(data_mat_genes)))
weight_matrix_genes[data_mat_genes != 0] <- 1  # Where data is non-zero, weight is 1
weight_matrix_genes[data_mat_genes == 0] <- (1 - as.matrix(zinb_probs_genes)[data_mat_genes == 0]) * 0.01
weight_matrix_genes[as.matrix(zinb_probs_genes) == 1 & data_mat_genes == 0] <- 10^(-15)

weight_matrix_orgs <- matrix(0, nrow = nrow(data_mat_orgs), ncol = ncol(data_mat_orgs),
                        dimnames = list(rownames(data_mat_orgs), colnames(data_mat_orgs)))

weight_matrix_orgs[data_mat_orgs != 0] <- 1  # Where data is non-zero, weight is 1
weight_matrix_orgs[data_mat_orgs == 0] <- (1 - as.matrix(zinb_probs_orgs)[data_mat_orgs == 0]) * 0.01
weight_matrix_orgs[as.matrix(zinb_probs_orgs) == 1 & data_mat_orgs == 0] <- 10^(-15)


# Correlation function
weighted_correlation <- function(x, y, weight_x, weight_y) {
  mean_x <- sum(weight_x * x) / sum(weight_x)
  mean_y <- sum(weight_y * y) / sum(weight_y)

  cov <- (weight_x * (x - mean_x) * weight_y * (y - mean_y))
  var_x <- (weight_x * (x - mean_x))^2
  var_y <- (weight_y * (y - mean_y))^2
    
  weighted_correlation_coefficient <- sum(cov) / sqrt(sum(var_x) * sum(var_y))
  return(weighted_correlation_coefficient)
}


# Calculate correlations
cat("Start loop\n")
correlation_coefficient <- vector("numeric", length = length(blast_gene_names))

for (i in 1:length(blast_gene_names)) {
  print(i)
  current_gene_name <- blast_gene_names[i]
  current_org_name <- blast_org_names[i]
  
  gene_row <- as.numeric(data_mat_genes[current_gene_name, , drop = FALSE]) # Find the corresponding row for the gene in the gene count matrix
  org_row <- as.numeric(data_mat_orgs[current_org_name, , drop = FALSE])

  gene_weight <- as.numeric(weight_matrix_genes[current_gene_name, , drop = FALSE])
  org_weight <- as.numeric(weight_matrix_orgs[current_org_name, , drop = FALSE])

  correlation_coefficient[i] <- weighted_correlation(gene_row, org_row, gene_weight, org_weight)
}


correlation_results <- data.frame(
  Gene = blast_gene_names,
  Organism = blast_org_names,
  CorrelationCoefficient = correlation_coefficient
)


cat("write")
write.table(correlation_results, file = results, sep = "\t", row.names = FALSE, quote = FALSE)

