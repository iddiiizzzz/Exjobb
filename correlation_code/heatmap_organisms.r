
# ---------------------------------------------------------
# Create a heatmap for correlations over gene vs gene
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)

# file_path <- "/storage/bergid/correlation/results_org_correlation_all_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_hg_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww2_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww1_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_all_log_sep75.tsv" 
#file_path <- "/storage/bergid/correlation/results_org_correlation_hg_log.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww2_log.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_all_log.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww1_log.tsv"

file_path <- "test_files/results_org_correlation_ww1_test.tsv"

correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
 
# Convert long format to a wide format (matrix)
cor_matrix <- dcast(correlations, Organism1 ~ Organism2, value.var = "CorrelationCoefficient")


# Convert to a proper matrix (remove first column)
rownames(cor_matrix) <- cor_matrix$Organism1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


# Create a color palette using RColorBrewer
my_palette <- colorRampPalette(c("blue", "white", "red"))(100)

png("test_files/heatmap_org_test.png", width = 30000, height = 30000, res = 4000)
pheatmap(cor_matrix, 
    col=my_palette,
    main = "Waste Water Correlation Heatmap", 
    fontsize_row = 0.3,
    fontsize_col = 0.3, 
    angle_col = 90)
dev.off()

