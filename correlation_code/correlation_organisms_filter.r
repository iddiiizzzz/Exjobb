
# -------------------------------------------------
# Calculate the correlation between orgnanisms
# -------------------------------------------------


library(Hmisc)      
library(reshape2)   


# count_matrix <- "test_files/rewritten_test_kraken1.tsv"
# results <- "test_files/results_org_correlation_ww1_test75.tsv"

# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_ww1_log75.tsv" #correlation_2
count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
results = "/storage/bergid/correlation/results_org_correlation_ww2_log75.tsv" #correlation_3
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_hg_log75.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_all_log75.tsv"


data <- read.table(count_matrix, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
org_names <- data$TrueID
rownames(data) <- org_names

data <- data[, -1]  
data <- data[(rowSums(data == 0) / ncol(data)) < 0.75, ]
data <- log(data + 1)


# Convert data to a numeric matrix while preserving row and column names.
data_mat <- as.matrix(data)
data_mat <- matrix(as.numeric(data_mat), 
                   nrow = nrow(data_mat), 
                   ncol = ncol(data_mat),
                   dimnames = list(rownames(data), colnames(data)))

res <- rcorr(t(data_mat), type = "pearson") # transpose bc default is correlation between columns, and organisms are rows


cor_matrix <- res$r
p_matrix   <- res$P

rownames(cor_matrix) <- rownames(data)
colnames(cor_matrix) <- rownames(data)
rownames(p_matrix)   <- rownames(data)
colnames(p_matrix)   <- rownames(data)

cor_long <- melt(cor_matrix, varnames = c("Organism1", "Organism2"), value.name = "CorrelationCoefficient")
p_long   <- melt(p_matrix,   varnames = c("Organism1", "Organism2"), value.name = "pValue")

result_df <- merge(cor_long, p_long, by = c("Organism1", "Organism2"))

write.table(result_df, file = results, sep = "\t", quote = FALSE, row.names = FALSE)
