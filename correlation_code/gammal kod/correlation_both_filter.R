
# -------------------------------------------------
# Calculate the correlation between genes ond organisms 
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   

count_matrix_genes = "/storage/koningen/final_count_matrix_genes.tsv" 
count_matrix_orgs = "/storage/koningen/final_count_matrix_orgs.tsv"
blast_results = "/storage/bergid/blast/blast_final.txt"
results = "/storage/bergid/correlation/both/correlation_filtered.tsv"

# count_matrix_genes = "test_files/matching_samples_genes.tsv"
# count_matrix_orgs = "test_files/matching_samples_orgs.tsv"
# blast_results = "test_files/blast_org_names.txt"
# results = "test_files/correlation_both_test.tsv"


blast_table <- read.table(blast_results, sep = "\t", header = TRUE, stringsAsFactors = FALSE, check.names=FALSE, fileEncoding = "UTF-8", comment = "", quote ="")
cat("blast read\n")

print(nrow(blast_table))

data_gene <- read.table(count_matrix_genes, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8", comment = "", quote ="")
gene_names <- data_gene$GeneNames
rownames(data_gene) <- gene_names
data_gene <- data_gene[, -1]  

data_mat_gene <- as.matrix(data_gene)
data_mat_gene <- matrix(as.numeric(data_mat_gene), 
                   nrow = nrow(data_mat_gene), 
                   ncol = ncol(data_mat_gene),
                   dimnames = list(rownames(data_gene), colnames(data_gene)))


data_org <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8", comment = "", quote ="")
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

blast_gene_names <- blast_table[15]
blast_org_names <- blast_table[16]
print(nrow(blast_gene_names))

relevant_gene_names <- c()
relevant_org_names <- c()
valid_correlations <- c()
valid_p_values <- c()


for (i in 1:nrow(blast_gene_names)) {
  print(i)
  current_gene_name <- as.character(blast_gene_names[i, 1])  
  current_org_name <- as.character(blast_org_names[i, 1])


  if (!(current_org_name %in% rownames(data_mat_org))) {
    print(paste("Organism not found:", current_org_name))
    next  # Skip this iteration if the organism is missing
  }
  # Check if the names exist in row names
  if (!(current_gene_name %in% rownames(data_mat_gene))) {
    print(paste("Gene not found:", current_gene_name))
    next  # Skip this iteration if the gene is missing
  }
  if (current_org_name == "Organism name not detected") {
    print(paste("Organism name not detected:", current_org_name))
    next
  }
  if (current_gene_name == "Gene name not detected") {
    print(paste("Gene name not detected:", current_gene_name))
    next
  }


  relevant_gene_names <- c(relevant_gene_names, current_gene_name)
  relevant_org_names <- c(relevant_org_names, current_org_name)
  
  gene_row <- data_mat_gene[current_gene_name, ]  
  org_row <- data_mat_org[current_org_name, ]
  
  correlation_result <- rcorr(as.numeric(gene_row), as.numeric(org_row), type = "pearson")

  valid_correlations <- c(valid_correlations, correlation_result$r[1, 2])
  valid_p_values <- c(valid_p_values, correlation_result$P[1, 2])

}


correlation_results <- data.frame(
  Gene = relevant_gene_names,
  Organism = relevant_org_names,
  CorrelationCoefficient = valid_correlations[1:length(relevant_gene_names)],  
  p_values = valid_p_values[1:length(relevant_org_names)]
)

cat("write")
write.table(correlation_results, file = results, sep = "\t", row.names = FALSE, quote = FALSE)
