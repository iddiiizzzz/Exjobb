
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
library(showtext)

# Latex font
font_add(family = "LM Roman", regular = "/storage/koningen/latex-font/lmroman10-regular.otf")
showtext_auto()

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
count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_all_genes.tsv"
count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_all_orgs.tsv"
output_file <- "checking_data/scatterplot_gene_vs_org_species_high_corr.eps"

# count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_hg_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_hg.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_species_hg.png"

# count_matrix_genes <- "/storage/koningen/species/normalize/normalized_count_matrix_ww_genes.tsv"
# count_matrix_orgs <- "/storage/koningen/species/normalize/normalized_count_matrix_ww.tsv"
# output_file <- "checking_data/scatterplot_gene_vs_org_species_ww.png"




gene <- "GCA_000203195.1_ASM20319v1_FR824044.1_seq1...tet_rpg" # High correlation
organism <- "Faecalibacillus intestinalis"

# gene <- "GCA_001670625.2_ASM167062v2_CP121209.1_seq1...class_A" # Low correlation
# organism <- "Croceicoccus marinus"


count_data_genes <- read.table(count_matrix_genes, sep = "\t", header = TRUE, row.names = 1)
count_data_orgs <- read.table(count_matrix_orgs, sep = "\t", header = TRUE, row.names = 1)


gene_counts <- as.numeric(count_data_genes[gene, ])
org_counts <- as.numeric(count_data_orgs[organism, ])



df <- data.frame(GeneCounts = gene_counts,
                  OrgCounts = org_counts)


ggplot(df, aes(x = GeneCounts, y = OrgCounts)) +
  geom_point(size = 0.75, color = "#9b13bb") +
  labs(x = paste("Count Values for the Gene"),
       y = paste("Count Values for the Host")) + 
  theme_bw() +
  theme(
    text = element_text(family = "LM Roman"),         # Set global font
    plot.title = element_text(size = 15),         # Title font size
    axis.title.x = element_text(size = 20),       # X-axis title font size
    axis.title.y = element_text(size = 20),       # Y-axis title font size
    axis.text.x = element_text(size = 15),        # X-axis tick label size
    axis.text.y = element_text(size = 15)         # Y-axis tick label size
  ) +
  ylim(0, 0.03) +
  xlim(0, 0.1)

ggsave(output_file, device = "eps", width = 7, height = 6) # device = "eps",
