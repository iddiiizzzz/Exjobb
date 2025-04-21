# ------------------------------------------------------------------------
# Calculate the correlation between organisms and genes using zero inflation as weights
# ------------------------------------------------------------------------

library(Hmisc)      
library(reshape2)
library(pbapply)

# Original

# count_matrix_genes = "/storage/koningen/genus/combined_matrices/taxonomy_all_genes.tsv"
# count_matrix_orgs = "/storage/koningen/genus/combined_matrices/taxonomy_all_organisms.tsv"
# blast_results = "/storage/bergid/blast/blast_final.txt"
# zinb_genes <- "/storage/koningen/genus/zero_inflations/zinb_matrix_all_genes.tsv" 
# zinb_orgs <- "/storage/koningen/genus/zero_inflations/zinb_matrix_all_orgs.tsv"
# results = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted.tsv"

# count_matrix_genes = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"
# count_matrix_orgs = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
# blast_results = "/storage/bergid/blast/blast_final.txt"
# zinb_genes <- "/storage/koningen/genus/zero_inflations/zinb_matrix_genes_ww.tsv"
# zinb_orgs <- "/storage/koningen/genus/zero_inflations/zinb_matrix_orgs_ww.tsv" 
# results = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_ww.tsv" 

# count_matrix_genes = "/storage/koningen/genus/filter_zeros/taxonomy_hg_genes_filtered.tsv"
# count_matrix_orgs = "/storage/koningen/genus/filter_zeros/taxonomy_hg_organisms_filtered.tsv"
# blast_results = "/storage/bergid/blast/blast_final.txt"
# zinb_genes <- "/storage/koningen/genus/zero_inflations/zinb_matrix_genes_hg.tsv" 
# zinb_orgs <- "/storage/koningen/genus/zero_inflations/zinb_matrix_orgs_hg.tsv"
# results = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_hg.tsv" 




# Normalized

count_matrix_genes = "/storage/koningen/genus/normalize/normalized_count_matrix_all_genes.tsv"
count_matrix_orgs = "/storage/koningen/genus/normalize/normalized_count_matrix_all_orgs.tsv"
blast_results = "/storage/bergid/blast/blast_final.txt"
zinb_genes <- "/storage/koningen/genus/zero_inflations/normalized_zinb_matrix_all_genes.tsv" 
zinb_orgs <- "/storage/koningen/genus/zero_inflations/normalized_zinb_matrix_all_orgs.tsv"
results = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_normalized.tsv" # ej körd -- NA?

# count_matrix_genes = "/storage/koningen/genus/normalize/normalized_count_matrix_ww_genes.tsv"
# count_matrix_orgs = "/storage/koningen/genus/normalize/normalized_count_matrix_ww.tsv"
# blast_results = "/storage/bergid/blast/blast_final.txt"
# zinb_genes <- "/storage/koningen/genus/zero_inflations/normalized_zinb_matrix_genes_ww.tsv" 
# zinb_orgs <- "/storage/koningen/genus/zero_inflations/normalized_zinb_matrix_orgs_ww.tsv" 
# results = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_ww.tsv" 

# count_matrix_genes = "/storage/koningen/genus/normalize/normalized_count_matrix_hg_genes.tsv"
# count_matrix_orgs = "/storage/koningen/genus/normalize/normalized_count_matrix_hg.tsv"
# blast_results = "/storage/bergid/blast/blast_final.txt"
# zinb_genes <- "/storage/koningen/genus/zero_inflations/normalized_zinb_matrix_genes_hg.tsv"
# zinb_orgs <- "/storage/koningen/genus/zero_inflations/normalized_zinb_matrix_orgs_hg.tsv" 
# results = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_hg.tsv" # ej körd -- NA?



# Read files
blast_table <- read.table(blast_results, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding="UTF-8", comment = "", quote ="")

data_gene <- read.table(count_matrix_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding="UTF-8", comment = "", quote ="")
gene_names <- data_gene$GeneNames
rownames(data_gene) <- gene_names
data_gene <- data_gene[, -1]  

data_org <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding="UTF-8", comment = "", quote ="")
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


# Read zero inflation files
zinb_probs_genes <- read.table(zinb_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding="UTF-8", comment = "", quote ="")
rownames(zinb_probs_genes) <- zinb_probs_genes$GeneNames
zinb_probs_genes <- zinb_probs_genes[, -1]  

zinb_probs_orgs <- read.table(zinb_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding="UTF-8", comment = "", quote ="")
rownames(zinb_probs_orgs) <- zinb_probs_orgs$OrgNames
zinb_probs_orgs <- zinb_probs_orgs[, -1]  


cat("Gene matrix dim: ", dim(data_mat_genes), "\n")
cat("ZINB gene matrix dim: ", dim(zinb_probs_genes), "\n")

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
blast_gene_names <- blast_table[15]
blast_org_names <- blast_table[16]
print(nrow(blast_gene_names))

relevant_gene_names <- c()
relevant_org_names <- c()
correlation_coefficient <- c()


for (i in 1:nrow(blast_gene_names)) { #nrow(blast_gene_names
  print(i)
  current_gene_name <- as.character(blast_gene_names[i, 1])  
  current_org_name <- as.character(blast_org_names[i, 1])
  
  if (!(current_org_name %in% rownames(data_mat_orgs))) {
    # print(paste("Organism not found:", current_org_name))
    next  # Skip this iteration if the organism is missing
  }
  # Check if the names exist in row names
  if (!(current_gene_name %in% rownames(data_mat_genes))) {
    # print(paste("Gene not found:", current_gene_name))
    next  # Skip this iteration if the gene is missing
  }
  if (current_org_name == "Organism name not detected") {
    # print(paste("Organism name not detected:", current_org_name))
    next
  }
  if (current_gene_name == "Gene name not detected") {
    # print(paste("Gene name not detected:", current_gene_name))
    next
  }
  
  relevant_gene_names <- c(relevant_gene_names, current_gene_name)
  relevant_org_names <- c(relevant_org_names, current_org_name)
  
  gene_row <- data_mat_genes[current_gene_name, ]  
  org_row <- data_mat_orgs[current_org_name, ]
  gene_weight <- weight_matrix_genes[current_gene_name, ]
  org_weight <- weight_matrix_orgs[current_org_name, ]


  correlation_coefficient <- c(correlation_coefficient, weighted_correlation(gene_row, org_row, gene_weight, org_weight))

}


correlation_results <- data.frame(
  Gene = relevant_gene_names,
  Organism = relevant_org_names,
  CorrelationCoefficient = correlation_coefficient
)


cat("write")
write.table(correlation_results, file = results, sep = "\t", row.names = FALSE, quote = FALSE)

