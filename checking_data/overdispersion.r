

library(ggplot2)

count_data <- read.table("/storage/koningen/count_matrix.tsv", sep = "\t", header = TRUE, row.names = 1)
output_file <- "checking_data/scatterplot_genes.png"


sampled_genes <- sample(rownames(count_data), 1000)  # Select 100 random genes
sampled_data <- count_data[sampled_genes, ]


gene_means <- rowMeans(sampled_data)
gene_variances <- apply(sampled_data, 1, var)


mean_var_df <- data.frame(Mean = gene_means, Variance = gene_variances)
mean_var_df <- mean_var_df[mean_var_df$Mean > 0 & mean_var_df$Variance > 0, ]

ggplot(mean_var_df, aes(x = Mean, y = Variance)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") + 
  scale_x_log10() + scale_y_log10() + 
  labs(title = "Variance vs. Mean Scatter Plot (Sampled Data)",
       x = "Mean Expression",
       y = "Variance") +
  theme_bw()



ggsave(output_file, bg = "white")