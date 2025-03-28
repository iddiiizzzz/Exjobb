
# -------------------------------------------------
# Calculate the correlation between genes, filter 75% zeros, 
# NOT UPDATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   


# count_matrix_genes = "/storage/koningen/filtered_count_matrix.tsv"
# count_matrix_orgs = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms_filtered.tsv"
# results = "/storage/bergid/correlation/both/correlation_filtered.tsv"
# blast_results = "/storage/bergid/blast/blast_results_corrected.txt"

count_matrix_genes = "test_files/test_gene_count_matrix_blast.tsv"
count_matrix_orgs = "test_files/count_matrix_orgs_test_blast.tsv"
results = "test_files/correlation_both_test.tsv"
blast_results = "test_files/blast_with_true_names_fixed.txt"


blast_table <- read.table(blast_results, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
cat("1\n")

data_gene <- read.table(count_matrix_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
gene_names <- data_gene$GeneNames
rownames(data_gene) <- gene_names
data_gene <- data_gene[, -1]  

data_mat_gene <- as.matrix(data_gene)
data_mat_gene <- matrix(as.numeric(data_mat_gene), 
                   nrow = nrow(data_mat_gene), 
                   ncol = ncol(data_mat_gene),
                   dimnames = list(rownames(data_gene), colnames(data_gene)))


data_org <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data_org$TrueID
rownames(data_org) <- org_names
data_org <- data_org[, -1]  

data_mat_org <- as.matrix(data_org)
data_mat_org <- matrix(as.numeric(data_mat_org), 
                   nrow = nrow(data_mat_org), 
                   ncol = ncol(data_mat_org),
                   dimnames = list(rownames(data_org), colnames(data_org)))


cat("2\n")

blast_gene_names <- blast_table$qseqid
blast_org_names <- blast_table$True_gene_names


correlations <- vector("numeric", length = length(blast_gene_names))
p_values <- vector("numeric", length = length(blast_gene_names))

for (i in 1:length(blast_gene_names)) {
  print(i)
  current_gene_name <- blast_gene_names[i]
  current_org_name <- blast_org_names[i]
  

  gene_row <- data_mat_gene[current_gene_name, , drop = FALSE] # Find the corresponding row for the gene in the gene count matrix
  org_row <- data_mat_org[current_org_name, , drop = FALSE]
  
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

cat("write")
write.table(correlation_results, file = results, sep = "\t", row.names = FALSE, quote = FALSE)
