
# ---------------------------------------------------------------
# Adding the three taxonomy files together into one big file
# ---------------------------------------------------------------

import pandas as pd

# humangut = "test_files/rewritten_test_kraken3.tsv"
# wastewater1 = "test_files/rewritten_test_kraken2.tsv"
# wastewater2 = "test_files/rewritten_test_kraken1.tsv"
# outfile = "test_files/test_all_organisms.tsv"

# humangut = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# wastewater1 = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# wastewater2 = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# outfile = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"

# wastewater1 = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# wastewater2 = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# outfile = "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv"

# wastewater1 = "/storage/bergid/zero_inflations/zinb_probabilities_ww.tsv"
# humangut = "/storage/bergid/zero_inflations/zinb_probabilities_hg.tsv"
# outfile = "/storage/koningen/zero_inflations/zinb_probabilities_all_organisms.tsv"


wastewater1 = "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms_filtered.tsv"
humangut = "/storage/bergid/taxonomy_rewrites/taxonomy_hg_organisms_filtered.tsv"
outfile = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms_filtered.tsv"


df_hgut = pd.read_csv(humangut, sep="\t", index_col=0)
df_waste1 = pd.read_csv(wastewater1, sep="\t", index_col=0)
# df_waste2 = pd.read_csv(wastewater2, sep="\t", index_col=0)

merged_df = pd.concat([df_hgut, df_waste1], axis=1, join="outer")
merged_df = merged_df.fillna(0) # 1 for zinb, 0 for counts
merged_df = merged_df.astype(int)
merged_df.to_csv(outfile, sep="\t")


