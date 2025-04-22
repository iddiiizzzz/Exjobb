
# ---------------------------------------------------------
# Create a heatmap for correlations over organism vs organism
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)

### Correlation weighted
## Normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_sorted.tsv"
# png <- "heatmaps/both/species/normalized_heatmap_species_weighted_all.png"

# ww
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_sorted.tsv"
# png <- "heatmaps/both/species/normalized_heatmap_species_weighted_ww.png"

# hg
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_sorted.tsv"
# png <- "heatmaps/both/species/normalized_heatmap_species_weighted_hg.png"


## Non-normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_sorted.tsv"
# png <- "heatmaps/both/species/heatmap_species_weighted_all.png"

# ww
# file_path <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_sorted.tsv"
# png <- "heatmaps/both/species/heatmap_species_weighted_ww.png"

#hg
# file_path <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_sorted.tsv"
# png <- "heatmaps/both/species/heatmap_species_weighted_hg.png"



### Correlation filtered
## Normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_sorted.tsv"
# png <- "heatmaps/both/species/normalized_heatmap_species_filtered_all.png"

# ww
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_sorted.tsv"
# png <- "heatmaps/both/species/normalized_heatmap_species_filtered_ww.png"

# hg
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_sorted.tsv"
# png <- "heatmaps/both/species/normalized_heatmap_species_filtered_hg.png"


## Non-normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/correlation_filtered_all_sorted.tsv"
# png <- "heatmaps/both/species/heatmap_species_filtered_all.png"

# ww
# file_path <- "/storage/bergid/correlation/species/both/correlation_filtered_ww_sorted.tsv"
# png <- "heatmaps/both/species/heatmap_species_filtered_ww.png"

#hg
file_path <- "/storage/bergid/correlation/species/both/correlation_filtered_hg_sorted.tsv"
png <- "heatmaps/both/species/heatmap_species_filtered_hg.png"




correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
cor_matrix <- dcast(correlations, Gene ~ Organism, value.var = "CorrelationCoefficient")

# Remove first column
rownames(cor_matrix) <- cor_matrix$Gene
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


my_palette <- colorRampPalette(c("blue", "white", "red"))(100)
breaks_list <- seq(-0.7, 0.7, length.out = 101)  # Ensures proper scaling from -1 to 1

# 5000 width/height + res 900 bra för 181 st
png(png, width = 6000, height = 6000, res = 900)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between -1 and 1
    # main = "ARG-Host Correlation Heatmap ", 
    fontsize_row = 1, 
    fontsize_col = 1, 
    angle_col = 90)
dev.off()