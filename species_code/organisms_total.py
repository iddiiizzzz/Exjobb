
# ---------------------------------------------------------------
# Adding the three taxonomy files together into one big file
# ---------------------------------------------------------------

import pandas as pd

## ww orgs
# wastewater1 = "/storage/koningen/species/matching_samples/matching_count_matrix_orgs_ww1.tsv"
# wastewater2 = "/storage/koningen/species/matching_samples/matching_count_matrix_orgs_ww2.tsv"
# outfile = "/storage/koningen/species/combined_matrices/taxonomy_all_ww_organisms.tsv"

## ww genes
# wastewater1 = "/storage/koningen/species/matching_samples/matching_count_matrix_genes_ww1.tsv"
# wastewater2 = "/storage/koningen/species/matching_samples/matching_count_matrix_genes_ww2.tsv"
# outfile = "/storage/koningen/species/combined_matrices/taxonomy_all_ww_organisms_genes.tsv"


## all orgs
# wastewater1 =  "/storage/koningen/species/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
# humangut = "/storage/koningen/species/filter_zeros/taxonomy_hg_organisms_filtered.tsv"
# outfile = "/storage/koningen/species/combined_matrices/taxonomy_all_organisms.tsv"


## all genes
wastewater1 = "/storage/koningen/species/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"
humangut = "/storage/koningen/species/filter_zeros/taxonomy_hg_genes_filtered.tsv"
outfile = "/storage/koningen/species/combined_matrices/taxonomy_all_genes.tsv"



df_hgut = pd.read_csv(humangut, sep="\t", index_col=0)
df_waste1 = pd.read_csv(wastewater1, sep="\t", index_col=0)
# df_waste2 = pd.read_csv(wastewater2, sep="\t", index_col=0)

# merged_df = pd.concat([df_waste1, df_waste2], axis=1, join="outer")
merged_df = pd.concat([df_waste1, df_hgut], axis=1, join="outer")
merged_df = merged_df.fillna(0) # 1 for zinb, 0 for counts
merged_df = merged_df.astype(int)
merged_df.to_csv(outfile, sep="\t")


