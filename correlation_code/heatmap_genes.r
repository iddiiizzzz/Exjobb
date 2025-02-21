
# ---------------------------------------------------------
# Create a heatmap for correlation over gene vs gene
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)



# correlations <- read.table("/storage/bergid/correlation/results_gene_correlation.tsv", 
#                            sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
correlations <- read.table("test_files/test_gene_correlation_results.tsv", 
                           sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)


# Convert long format to a wide format (matrix)
cor_matrix <- dcast(correlations, Gene1 ~ Gene2, value.var = "CorrelationCoefficient")


# Convert to a proper matrix (remove first column)
rownames(cor_matrix) <- cor_matrix$Gene1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


# Create a color palette using RColorBrewer
my_palette <- colorRampPalette(brewer.pal(9, "YlOrRd"))(100)

pdf("correlation_code/heatmap_all_genes_r_test.pdf")
# pdf("correlation_code/heatmap_all_genes_r.pdf")
heatmap.2(cor_matrix, main = "Gene Correlation Heatmap", 
col=my_palette,
trace = "none",
margins = c(12,12))
dev.off()


# tar kanske 20 min för generna
