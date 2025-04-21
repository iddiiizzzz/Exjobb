
# ---------------------------------------------------------------
# Adding the three taxonomy files together into one big file
# ---------------------------------------------------------------

import pandas as pd


# Organisms
# wastewater1 = "/storage/koningen/genus/matching_samples/matching_count_matrix_orgs_ww1.tsv"
# wastewater2 = "/storage/koningen/genus/matching_samples/matching_count_matrix_orgs_ww2.tsv"
# outfile = "/storage/koningen/genus/combined_matrices/taxonomy_all_ww_organisms.tsv"

wastewater1 = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
humangut = "/storage/koningen/genus/filter_zeros/taxonomy_hg_organisms_filtered.tsv"
outfile = "/storage/koningen/genus/combined_matrices/taxonomy_all_organisms.tsv"


# Genes
# wastewater1 = "/storage/koningen/genus/matching_samples/matching_count_matrix_genes_ww1.tsv"
# wastewater2 = "/storage/koningen/genus/matching_samples/matching_count_matrix_genes_ww2.tsv"
# outfile = "/storage/koningen/genus/combined_matrices/taxonomy_all_ww_genes.tsv"

# wastewater1 = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"
# humangut = "/storage/koningen/genus/filter_zeros/taxonomy_hg_genes_filtered.tsv"
# outfile = "/storage/koningen/genus/combined_matrices/taxonomy_all_genes.tsv"



df_hgut = pd.read_csv(humangut, sep="\t", index_col=0)
df_waste1 = pd.read_csv(wastewater1, sep="\t", index_col=0)
# df_waste2 = pd.read_csv(wastewater2, sep="\t", index_col=0)

merged_df = pd.concat([df_waste1, df_hgut], axis=1, join="outer")
merged_df = merged_df.fillna(0) # 1 for zinb, 0 for counts
merged_df = merged_df.astype(int)
merged_df.to_csv(outfile, sep="\t")


