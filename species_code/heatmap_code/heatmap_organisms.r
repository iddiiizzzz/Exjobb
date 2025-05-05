
# ---------------------------------------------------------
# Create a heatmap for correlations over organism vs organism
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)

# file_path  <- "/storage/bergid/correlation/organisms/org_correlation_separate_filtering.tsv" #KLAR
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_filtered.png" 

# file_path <- "/storage/bergid/correlation/organisms/org_correlation_zero_inflation_probabilities.tsv" #KLAR
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_probabilities.png" 

file_path <- "/storage/bergid/correlation/genes/orgs_correlation_zero_inflation_weighted.tsv"  #KLAR
png <- "correlation_code/heatmaps/organisms/heatmap_orgs_weighted.png" 

# file_path <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_09.tsv" #KLAR
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_threshold_09.png"

# file_path <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_07.tsv" #KLAR
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_threshold_07.png"

# file_path <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_06.tsv"  #KLAR
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_threshold_06.png" 
 

correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE, fileEncoding = "UTF-8")
cor_matrix <- dcast(correlations, Organism1 ~ Organism2, value.var = "CorrelationCoefficient")
cat("done reading data\n")
# Remove first column
rownames(cor_matrix) <- cor_matrix$Organism1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0

cat("making heatmap\n")
my_palette <- colorRampPalette(c("blue", "white", "red"))(100)
# breaks_list <- seq(-1, 1, length.out = 101)  # Ensures proper scaling from -1 to 1

# Define a nonlinear (squared) color scale
vals <- seq(-1, 1, length.out = 101)  # use full correlation range
breaks_list <- sign(vals) * (abs(vals)^2) * 0.7  # scale to match your limits

# 5000 width/height + res 900 bra för 181 st
png(png, width = 30000, height = 30000, res = 4000)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between -1 and 1
    # main = "Organisms Correlation (threshold 0.6)",
    # main = "Organisms Correlation (threshold 0.7)",
    # main = "Organisms Correlation (threshold 0.9)",
    # main = "Organisms Correlation (probabilities)",
    main = "Organisms Correlation (weighted)",
    # main = "Organisms Correlation (filtered)",
    fontsize_row = 0.15, 
    fontsize_col = 0.15, 
    angle_col = 90)
dev.off()

