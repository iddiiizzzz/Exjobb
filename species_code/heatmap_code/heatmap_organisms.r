
# ------------------------------------------------------------------------------------------------------------

# Create a heatmap for correlations over organism vs organism.

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

# file_path  <- "/storage/bergid/correlation/organisms/org_correlation_separate_filtering.tsv" 
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_filtered.png" 

# file_path <- "/storage/bergid/correlation/organisms/org_correlation_zero_inflation_probabilities.tsv" 
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_probabilities.png" 

file_path <- "/storage/bergid/correlation/genes/orgs_correlation_zero_inflation_weighted.tsv" 
png <- "correlation_code/heatmaps/organisms/heatmap_orgs_weighted.png" 

# file_path <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_09.tsv" 
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_threshold_09.png"

# file_path <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_07.tsv" 
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_threshold_07.png"

# file_path <- "/storage/bergid/correlation/organisms/orgs_correlation_zero_inflation_threshold_06.tsv"  
# png <- "correlation_code/heatmaps/organisms/heatmap_orgs_threshold_06.png" 
 

correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE, fileEncoding = "UTF-8")
cor_matrix <- dcast(correlations, Organism1 ~ Organism2, value.var = "CorrelationCoefficient")

rownames(cor_matrix) <- cor_matrix$Organism1
cor_matrix <- as.matrix(cor_matrix[,-1])
cor_matrix[is.na(cor_matrix)] <- 0


vals <- seq(-1, 1, length.out = 101)  
breaks_list <- sign(vals) * (abs(vals)^2) * 0.7  

my_palette <- colorRampPalette(c("blue", "white", "red"))(100)

# 5000 width/height + res 900 bra för 181 st
png(png, width = 30000, height = 30000, res = 4000)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between -1 and 1
    main = "Organisms Correlation (weighted)",
    fontsize_row = 0.15, 
    fontsize_col = 0.15, 
    angle_col = 90)
dev.off()

