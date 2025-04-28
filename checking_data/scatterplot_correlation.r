

library(ggplot2)
library(reshape2)

# count_matrix_genes <- "/storage/koningen/genus/combined_matrices/taxonomy_all_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/genus/combined_matrices/taxonomy_all_organisms.tsv"
count_matrix_genes <- "/storage/koningen/species/combined_matrices/taxonomy_all_genes.tsv"
count_matrix_orgs <- "/storage/koningen/species/combined_matrices/taxonomy_all_organisms.tsv"

output_file <- "checking_data/correlation_plots/scatterplot_corr_species_2.png"


gene <- "GCA_001572875.1_ASM157287v1_LRUV01000056.1_seq1...class_D_2"
organism <- "Serratia rhizosphaerae"



count_data_genes <- read.table(count_matrix_genes, sep = "\t", header = TRUE, row.names = 1)
count_data_orgs <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, row.names = 1)


gene_counts <- count_data_genes[gene, ]
org_counts <- count_data_orgs[organism, ]

gene_df <- data.frame(Sample = colnames(gene_counts),
                      Count = as.numeric(gene_counts),
                      Type = "Gene")

org_df <- data.frame(Sample = colnames(org_counts),
                     Count = as.numeric(org_counts),
                     Type = "Organism")

combined_df <- rbind(gene_df, org_df)


ggplot(combined_df, aes(x = Sample, y = Count, color = Type, shape = Type)) +
  geom_point(alpha = 0.6, size = 0.1) +
  labs(title = paste(gene, "and", organism),
       x = "Sample",
       y = "Count Value") + 
  theme_bw() + 
  scale_color_manual(values = c("Gene" = "blue", "Organism" = "red")) +
  scale_shape_manual(values = c("Gene" = 20, "Organism" = 16)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 0.01))

ggsave(output_file, bg = "white", width = 12, height = 8, dpi = 900)
