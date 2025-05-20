
# ------------------------------------------------------------------------------------------------------------

# Creates a scatterplot of the dispersion of the data.

# Input:
#     - count_matrix: Path to the count matrix.

# Output:
#     - output_file: Path to where the scatter plot is stored.

# ------------------------------------------------------------------------------------------------------------



library(ggplot2)
library(showtext)

# Latex font
font_add(family = "LM Roman", regular = "/storage/koningen/latex-font/lmroman10-regular.otf")
showtext_auto()




count_matrix <-  "/storage/koningen/species/combined_matrices/taxonomy_all_orgs_unfiltered.tsv"
output_file <- "checking_data/scatterplot_orgs.eps"

# count_matrix <- "/storage/koningen/count_matrix.tsv"
# output_file <- "checking_data/scatterplot_genes.eps"


count_data <- read.table(count_matrix, sep = "\t", header = TRUE, row.names = 1)

sampled_genes <- sample(rownames(count_data), 200)  # Select random genes
sampled_data <- count_data[sampled_genes, ]


gene_means <- rowMeans(sampled_data)
gene_variances <- apply(sampled_data, 1, var)


mean_var_df <- data.frame(Mean = gene_means, Variance = gene_variances)
mean_var_df <- mean_var_df[mean_var_df$Mean > 0 & mean_var_df$Variance > 0, ]




ggplot(mean_var_df, aes(x = Mean, y = Variance)) +
  geom_point(color = "#9b13bb") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") + 
  scale_x_log10() + scale_y_log10() + 
  labs(x = "Mean Expression",
       y = "Variance") +
  theme_bw() + theme(
    text = element_text(family = "LM Roman"),         # Set global font
    plot.title = element_text(size = 15),         # Title font size
    axis.title.x = element_text(size = 20),       # X-axis title font size
    axis.title.y = element_text(size = 20),       # Y-axis title font size
    axis.text.x = element_text(size = 15),        # X-axis tick label size
    axis.text.y = element_text(size = 15)         # Y-axis tick label size
  ) 



ggsave(output_file, device = "eps", bg = "white") # device = "eps",