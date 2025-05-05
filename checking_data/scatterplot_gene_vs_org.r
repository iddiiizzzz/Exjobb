
# ------------------------------------------------------------------------------------------------------------

# Creates a scatterplot of the count values for one gene and one organism.

# Input:
#     - count_matrix_genes: Path to the count matrix for genes.
#     - count_matrix_orgs: Path to the count matrix for organisms.

# Output:
#     - output_file: Path to where the scatter plot is stored.

# Notes:
#     - Change the gene and organism names depending on which pair to examine.
#     - Change the out commented paths depending on which matrices to examine.

# ------------------------------------------------------------------------------------------------------------


library(ggplot2)
library(reshape2)

count_matrix_genes <- "/storage/koningen/genus/normalize/normalized_count_matrix_all_genes.tsv"
count_matrix_orgs <- "/storage/koningen/genus/normalize/normalized_count_matrix_all_orgs.tsv"
output_file <- "checking_data/scatterplot_gene_vs_org_genus.png"


# count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_all_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_all_orgs.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_species.png"


gene <- "GCA_000203195.1_ASM20319v1_FR824044.1_seq1...tet_rpg"
organism <- "Eubacterium"



count_data_genes <- read.table(count_matrix_genes, sep = "\t", header = TRUE, row.names = 1)
count_data_orgs <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, row.names = 1)


gene_counts <- as.numeric(count_data_genes[gene, ])
org_counts <- as.numeric(count_data_orgs[organism, ])



df <- data.frame(GeneCounts = gene_counts,
                  OrgCounts = org_counts)


ggplot(df, aes(x = GeneCounts, y = OrgCounts)) +
  geom_point(alpha = 0.6, size = 0.1) +
  labs(title = paste(gene, "and", organism),
       x = "Gene Count Value",
       y = "Organism Count Value") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 0.01))

ggsave(output_file, bg = "white", width = 12, height = 8, dpi = 900)
