
# ---------------------------------------------------------------
# Adding the three taxonomy files together into one big file
# ---------------------------------------------------------------

import pandas as pd

# wastewater1 = "/storage/bergid/zero_inflations/zinb_probabilities_ww.tsv"
# humangut = "/storage/bergid/zero_inflations/zinb_probabilities_hg.tsv"
# outfile = "/storage/koningen/zero_inflations/zinb_probabilities_all_organisms.tsv"

# wastewater1 = "/storage/koningen/genus/taxonomy_ww1.tsv"
# wastewater2 = "/storage/koningen/genus/taxonomy_ww2.tsv"
# outfile = "/storage/koningen/genus/taxonomy_all_ww_organisms.tsv"

wastewater1 = "/storage/koningen/genus/taxonomy_all_ww_organisms_filtered.tsv"
humangut = "/storage/koningen/genus/taxonomy_hg_organisms_filtered.tsv"
outfile = "/storage/koningen/genus/taxonomy_all_organisms_filtered.tsv"

df_hgut = pd.read_csv(humangut, sep="\t", index_col=0)
df_waste1 = pd.read_csv(wastewater1, sep="\t", index_col=0)
# df_waste2 = pd.read_csv(wastewater2, sep="\t", index_col=0)

merged_df = pd.concat([df_waste1, df_hgut], axis=1, join="outer")
merged_df = merged_df.fillna(0) # 1 for zinb, 0 for counts
merged_df = merged_df.astype(int)
merged_df.to_csv(outfile, sep="\t")


