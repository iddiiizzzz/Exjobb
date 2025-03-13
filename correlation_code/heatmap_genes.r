
# ---------------------------------------------------------
# Create a heatmap for correlation over gene vs gene
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)

file_path <- "test_files/correlation_zinb_threshold_test.tsv"
png <- "test_files/heatmap_gene_test_na.png"

# file_path <- "/storage/bergid/correlation/genes/gene_correlation.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes.png"
# file_path <- "/storage/bergid/correlation/genes/gene_correlation_filtered.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes_filtered.png"

# file_path <- "/storage/bergid/correlation/genes/genes_correlation_double_zeros.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes_double_zeros.png"

correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
cor_matrix <- dcast(correlations, Gene1 ~ Gene2, value.var = "CorrelationCoefficient")

# Remove first column
rownames(cor_matrix) <- cor_matrix$Gene1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


my_palette <- colorRampPalette(c("blue", "white", "red"))(100)
breaks_list <- seq(-1, 1, length.out = 101)  # Ensures proper scaling from -1 to 1

png(png, width = 32700, height = 32700, res = 6000)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between -1 and 1
    main = "Resistant Gene Correlation Heatmap (Without double zeros)", 
    fontsize_row = 1, 
    fontsize_col = 1,
    angle_col = 90)
dev.off()



# ish 1-2h
