
# ---------------------------------------------------------
# Create a heatmap for correlation over gene vs gene
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)

# file_path <- "/storage/bergid/correlation/results_gene_correlation.tsv"
# png <- ""

# file_path <- "test_files/gene_correlation_results_test.tsv"
# png <- "test_files/heatmap_gene_test.png"
file_path <- "test_files/gene_correlation_results_test75.tsv"
png <- "test_files/heatmaps/heatmap_gene_test75.png"


correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
cor_matrix <- dcast(correlations, Gene1 ~ Gene2, value.var = "CorrelationCoefficient")

# Remove first column
rownames(cor_matrix) <- cor_matrix$Gene1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


my_palette <- colorRampPalette(c("blue", "white", "red"))(100)
breaks_list <- seq(-1, 1, length.out = 101)  # Ensures proper scaling from -1 to 1

png(png, width = 30000, height = 30000, res = 4000)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between -1 and 1
    main = "Resistant Gene Correlation Heatmap", 
    fontsize_row = 0.3, 
    fontsize_col = 0.3, 
    angle_col = 90)
dev.off()



# tar kanske 20 min för generna
