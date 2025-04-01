
# -------------------------------------------------
# Calculate the correlation between genes ond organisms 
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   

count_matrix_genes = "/storage/koningen/final_count_matrix_genes.tsv" # kolla om den första genen i listan finns i matrisen osv
count_matrix_orgs = "/storage/koningen/final_count_matrix_orgs.tsv"
# blast_results = "/storage/bergid/blast/blast_final.txt"
# results = "/storage/bergid/correlation/both/correlation_filtered.tsv"

# count_matrix_genes = "test_files/matching_samples_genes.tsv"
# count_matrix_orgs = "test_files/matching_samples_orgs.tsv"
blast_results = "test_files/blast_org_names.txt"
results = "test_files/correlation_both_test.tsv"


blast_table <- read.table(blast_results, sep = "\t", header = TRUE, stringsAsFactors = FALSE, check.names=FALSE)
cat("1\n")
print(dim(blast_table))

data_gene <- read.table(count_matrix_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")
gene_names <- data_gene$GeneNames
rownames(data_gene) <- gene_names
data_gene <- data_gene[, -1]  

data_mat_gene <- as.matrix(data_gene)
data_mat_gene <- matrix(as.numeric(data_mat_gene), 
                   nrow = nrow(data_mat_gene), 
                   ncol = ncol(data_mat_gene),
                   dimnames = list(rownames(data_gene), colnames(data_gene)))


data_org <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE, encoding="utf-8")
org_names <- data_org$OrgNames
rownames(data_org) <- org_names
data_org <- data_org[, -1]  

data_mat_org <- as.matrix(data_org)
data_mat_org <- matrix(as.numeric(data_mat_org), 
                   nrow = nrow(data_mat_org), 
                   ncol = ncol(data_mat_org),
                   dimnames = list(rownames(data_org), colnames(data_org)))
# print(dim(data_mat_gene))

cat("2\n")
print(dim(blast_table))
blast_gene_names <- blast_table[15]
blast_org_names <- blast_table[16]
print(dim(blast_gene_names))
print(dim(blast_org_names))

correlations <- vector("numeric", length = length(blast_gene_names))
p_values <- vector("numeric", length = length(blast_gene_names))


for (i in 1:nrow(blast_gene_names)) {
  print(i)
  current_gene_name <- blast_gene_names[i, 1]  # Extract the gene name
  current_org_name <- blast_org_names[i, 1]
  print(current_gene_name)  # Print or use it for further analysis
  print(current_org_name)

  gene_row <- data_mat_gene[current_gene_name, ]  
  org_row <- data_mat_org[current_org_name, ]

  # gene_row <- data_mat_gene[current_gene_name, , drop = FALSE] # Find the corresponding row for the gene in the gene count matrix
  # org_row <- data_mat_org[current_org_name, , drop = FALSE]
  
  correlation_result <- rcorr(as.numeric(gene_row), as.numeric(org_row), type = "pearson")

  correlations[i] <- correlation_result$r[1, 2] 
  p_values[i] <- correlation_result$P[1, 2]

}

correlation_results <- data.frame(
  Gene = blast_gene_names,
  Organism = blast_org_names,
  CorrelationCoefficient = correlations,
  p_values = p_values
)

global_correlation_results <<- correlation_results

cat("write")
write.table(correlation_results, file = results, sep = "\t", row.names = FALSE, quote = FALSE)
