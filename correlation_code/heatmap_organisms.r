
# ---------------------------------------------------------
# Create a heatmap for correlations over gene vs gene
# ---------------------------------------------------------

library(ggplot2)
library(reshape2)  
library(pheatmap)  
library(gplots)
library(RColorBrewer)


correlations <- read.table("test_files/results_org_correlation_ww1_test.tsv", 
                           sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)

# correlations <- read.table("/storage/bergid/correlation/results_org_correlation_ww1_r.tsv", 
#                            sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
# correlations <- read.table("/storage/bergid/correlation/results_org_correlation_ww2.tsv", 
#                            sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
# correlations <- read.table("/storage/bergid/correlation/results_org_correlation_hg.tsv", 
#                            sep = "", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)


# Convert long format to a wide format (matrix)
cor_matrix <- dcast(correlations, Organism1 ~ Organism2, value.var = "CorrelationCoefficient")


# Convert to a proper matrix (remove first column)
rownames(cor_matrix) <- cor_matrix$Organism1
cor_matrix <- as.matrix(cor_matrix[,-1])

# Handle missing values
cor_matrix[is.na(cor_matrix)] <- 0


# Create a color palette using RColorBrewer
my_palette <- colorRampPalette(brewer.pal(9, "YlOrRd"))(100)

pdf("correlation_code/heatmap_org_ww1.pdf")
heatmap.2(cor_matrix, main = "Organism Correlation Heatmap", 
col=my_palette,
trace = "none",
margins = c(12,12))
dev.off()



