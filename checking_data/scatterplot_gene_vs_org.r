
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

# Genus
# count_matrix_genes <- "/storage/koningen/genus/normalize/normalized_count_matrix_all_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/genus/normalize/normalized_count_matrix_all_orgs.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_genus_low.png"

# count_matrix_genes <- "/storage/koningen/genus/normalize/normalized_count_matrix_hg_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/genus/normalize/normalized_count_matrix_hg.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_genus_hg.png"

# count_matrix_genes <- "/storage/koningen/genus/normalize/normalized_count_matrix_ww_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/genus/normalize/normalized_count_matrix_ww.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_genus_ww.png"


# Species
# count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_all_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_all_orgs.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_species.png"

# count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_hg_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_hg.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_species_hg.png"

count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_ww_genes.tsv"
count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_ww.tsv"
output_file <- "checking_data/scatterplot_gene_vs_org_species_ww.png"




gene <- "GCA_945987735.1_ERR2020023_bin.17_metaWRAP_v1.3_MAG_CAMFTF010000038.1_seq1...erm_typeF"
organism <- "Aerococcus urinaeequi"



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
  ylim(0, 0.04)

ggsave(output_file, bg = "white", width = 12, height = 8, dpi = 900)
