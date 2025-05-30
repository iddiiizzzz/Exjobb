
# ------------------------------------------------------------------------------------------------------------

# Create a heatmap for correlations over gene vs gene.

# Input:
#     - file_path: Path to the correlation list file.

# Output:
#     - png: Path to the created image in png format.

# Notes:
#     - Change the out commented files depending on which data to use.
#     - Change the title depending on the data.

# ------------------------------------------------------------------------------------------------------------


library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)



# file_path <- "/storage/bergid/correlation/genes/gene_correlation.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes.png"

# file_path <- "/storage/bergid/correlation/genes/gene_correlation_filtered_90.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes_filtered_90.png"

# file_path <- "/storage/bergid/correlation/genes/genes_correlation_double_zeros_90.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes_double_zeros_90.png"



# file_path <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_weighted_apply.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes_weighted.png"

# file_path <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_probabilities.tsv"
# png <- "correlation_code/heatmaps/genes/heatmap_genes_probabilities.png"

file_path <- "/storage/bergid/correlation/genes/genes_correlation_zero_inflation_threshold.tsv"
png <- "correlation_code/heatmaps/genes/heatmap_genes_threshold.png"





correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
cor_matrix <- dcast(correlations, Gene1 ~ Gene2, value.var = "CorrelationCoefficient")


rownames(cor_matrix) <- cor_matrix$Gene1
cor_matrix <- as.matrix(cor_matrix[,-1])
cor_matrix[is.na(cor_matrix)] <- 0


vals <- seq(-1, 1, length.out = 101)  
breaks_list <- sign(vals) * (abs(vals)^2) * 0.7  

my_palette <- colorRampPalette(c("blue", "white", "red"))(100)

# 5000 width/height + res 900 bra för 181 st
png(png, width = 5000, height = 5000, res = 900)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between -1 and 1
    main = "Resistant Gene Correlation (threshold 0.9, 90%)", 
    fontsize_row = 1, 
    fontsize_col = 1,
    angle_col = 90)
dev.off()

