
# ---------------------------------------------------------
# Create a heatmap for correlation over gene vs gene
# ---------------------------------------------------------

# Load necessary libraries
library(ggplot2)
library(reshape2)  # For reshaping data
library(pheatmap)  # For heatmap plotting

# Read the file
correlations <- read.table("/storage/bergid/correlation/results_gene_correlation.tsv", 
                           sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# correlations <- read.table("test_files/test_gene_correlation_results.tsv", 
#                            sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
# print(colnames(correlations))

# Convert long format to a wide format (matrix)
cor_matrix <- dcast(correlations, Gene1 ~ Gene2, value.var = "CorrelationCoefficient")
# print(dim(cor_matrix))
# print(head(cor_matrix))

# Convert to a proper matrix (remove first column)
rownames(cor_matrix) <- cor_matrix$Gene1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


pdf("correlation_code/heatmap_all_genes_r.pdf", width = 10, height = 10)

pheatmap(cor_matrix, 
         color = colorRampPalette(c("blue", "white", "red"))(50),
         main = "Gene Correlation Heatmap",
         cluster_rows = TRUE, cluster_cols = TRUE, 
         fontsize = 8, show_rownames = TRUE, show_colnames = TRUE)


dev.off()


# another way:
# Convert matrix back to long format for ggplot2
# cor_long <- melt(cor_matrix, na.rm = TRUE)

# ggplot(cor_long, aes(x=Var1, y=Var2, fill=value)) + 
#   geom_tile() + 
#   scale_fill_gradient2(low="blue", mid="white", high="red") +
#   theme_minimal() +
#   labs(title="Gene Correlation Heatmap", x="Gene 1", y="Gene 2")
