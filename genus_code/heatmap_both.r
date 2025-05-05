
# ---------------------------------------------------------
# Create a heatmap for correlations over organism vs organism
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)



# Weighted correlation (non-normalized)

# file_path <- "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_status.tsv" 
# png <- "heatmaps/both/genus/heatmap_genus_weighted_all.png"

# file_path <- "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_ww_status.tsv"
# png <- "heatmaps/both/genus/heatmap_genus_weighted_ww.png"

# file_path <- "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_hg_status.tsv"
# png <- "heatmaps/both/genus/heatmap_genus_weighted_hg.png"


# Weighted correlation (normalized)

# file_path <- "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_status.tsv"
# png <- "heatmaps/both/genus/normalized_heatmap_genus_weighted_all.png"

# file_path <- "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_ww_status.tsv"
# png <- "heatmaps/both/genus/normalized_heatmap_genus_weighted_ww.png"

# file_path <- "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_hg_status.tsv"
# png <- "heatmaps/both/genus/normalized_heatmap_genus_weighted_hg.png"




# Filtered correlation (non-normalized)

# file_path <- "/storage/bergid/correlation/genus/both/correlation_filtered_status.tsv"
# png <- "heatmaps/both/genus/heatmap_genus_filtered_all.png"

# file_path <- "/storage/bergid/correlation/genus/both/correlation_filtered_ww_status.tsv"
# png <- "heatmaps/both/genus/heatmap_genus_filtered_ww.png"

# file_path <- "/storage/bergid/correlation/genus/both/correlation_filtered_hg_status.tsv"
# png <- "heatmaps/both/genus/heatmap_genus_filtered_hg.png"


# Filtered correlation (normalized)

# file_path <- "/storage/bergid/correlation/genus/both/normalized_correlation_filtered_status.tsv"  
# png <-  "heatmaps/both/genus/normalized_heatmap_genus_filtered_all.png"

# file_path <- "/storage/bergid/correlation/genus/both/normalized_correlation_filtered_ww_status.tsv"
# png <- "heatmaps/both/genus/normalized_heatmap_genus_filtered_ww.png"

# file_path <- "/storage/bergid/correlation/genus/both/noremalized_correlation_filtered_hg_status.tsv"
# png <- "heatmaps/both/genus/test.png"
# png <- "heatmaps/both/genus/normalized_heatmap_genus_filtered_hg.png"



# correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
# cor_matrix <- dcast(correlations, Gene ~ Organism, value.var = "CorrelationCoefficient")

# # Remove first column
# rownames(cor_matrix) <- cor_matrix$Gene
# cor_matrix <- as.matrix(cor_matrix[,-1])


correlations <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)

# Add '*' to genes with Latent status
correlations$Gene <- ifelse(correlations$Gene.status == "Latent", 
                            paste0(correlations$Gene, "*"), 
                            correlations$Gene)

cor_matrix <- dcast(correlations, Gene ~ Organism, value.var = "CorrelationCoefficient")


rownames(cor_matrix) <- cor_matrix$Gene
cor_matrix <- as.matrix(cor_matrix[,-1])

cor_matrix[is.na(cor_matrix)] <- 0


my_palette <- colorRampPalette(c("blue", "white", "red"))(100)
# breaks_list <- seq(-0.7, 0.7, length.out = 101)  # Ensures proper scaling from -1 to 1

# Define a nonlinear (squared) color scale
vals <- seq(-1, 1, length.out = 101)  # use full correlation range
breaks_list <- sign(vals) * (abs(vals)^2) * 0.7  # scale to match your limits
display_vals <- ifelse(cor_matrix != 0, "*", "")

# 5000 width/height + res 900 bra för 181 st
png(png, width = 6000, height = 6000, res = 900)
pheatmap(cor_matrix, 
    col = my_palette, 
    breaks = breaks_list,  # Fix scale between chosen values
    display_numbers = display_vals,
    fontsize_number = 4, # storlek på *
    # main = "ARG-Host Correlation Heatmap (filtered)", 
    fontsize_row = 1, 
    fontsize_col = 1, 
    angle_col = 90)
dev.off()



