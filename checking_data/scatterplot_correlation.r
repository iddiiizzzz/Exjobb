

library(ggplot2)
library(reshape2)

count_data_genes <- read.table("/storage/koningen/genus/combined_matrices/taxonomy_all_genes.tsv", sep = "\t", header = TRUE, row.names = 1)
count_data_orgs <- read.table("/storage/koningen/genus/combined_matrices/taxonomy_all_organisms.tsv", sep = "\t", header = TRUE, row.names = 1)
output_file <- "checking_data/test.png"


gene <- "GCA_025660525.1_ASM2566052v1_JAOSFK010000051.1_seq1...class_D_2"
organism <- "Lysobacter"

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

ggsave(output_file, bg = "white", width = 12, height = 5, dpi = 900)
