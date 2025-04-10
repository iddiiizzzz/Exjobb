
# ----------------------------------------------------------------
# Rewrite the taxonomy count files to the gene count format
# ----------------------------------------------------------------

import pandas as pd


# taxonomy_file = "/storage/koningen/wastewater1/filtered_tax_counts_ww1.tsv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# #
# taxonomy_file = "/storage/koningen/wastewater2/filtered_tax_counts_ww2.tsv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"

taxonomy_file = "/storage/koningen/humangut/filtered_tax_counts_hg.tsv"
new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"


# taxonomy_file = "test_files/tax_counts_filtered1.tsv"
# taxonomy_file = "test_files/tax_counts_filtered2.tsv"
# taxonomy_file = "test_files/tax_counts_filtered3.tsv"
# new_taxonomy_file = "test_files/rewritten_test_kraken1.tsv"
# new_taxonomy_file = "test_files/rewritten_test_kraken2.tsv"
# new_taxonomy_file = "test_files/rewritten_test_kraken3.tsv"

df = pd.read_csv(taxonomy_file, delimiter='\t', na_values=[""])
df = df.fillna(0)


# Convert to integers
for col in df.columns:
    if df[col].dtype != object: 
        df[col] = df[col].astype(int)


df_transposed = df.transpose()
df_transposed.columns = df_transposed.iloc[0]
df_transposed = df_transposed[1:] 
df_transposed.insert(0, 'OrgNames', df.columns[1:])
df_transposed.to_csv(new_taxonomy_file, sep="\t", index=False, header=True)

