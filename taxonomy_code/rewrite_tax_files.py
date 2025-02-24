
# ----------------------------------------------------------------
# Rewrite the taxonomy count files to the gene count format
# ----------------------------------------------------------------

import pandas as pd

taxonomy_file = "test_files/test_kraken1.tsv"
new_taxonomy_file = "test_files/rewritten_test_kraken1.tsv"
#
# taxonomy_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
#
# taxonomy_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# #
# taxonomy_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"


df = pd.read_csv(taxonomy_file, sep="\s+", engine="python")
df = df.fillna(0)

# Convert to integers
for col in df.columns:
    if df[col].dtype != object: 
        df[col] = df[col].astype(int)


df_transposed = df.transpose()
df_transposed.columns = df_transposed.iloc[0]
df_transposed = df_transposed[1:] 
df_transposed.insert(0, 'TrueID', df.columns[1:])
df_transposed.to_csv(new_taxonomy_file, sep="\t", index=False, header=True)

'''
python histograms/organisms/rewrite_tax_files.py
'''