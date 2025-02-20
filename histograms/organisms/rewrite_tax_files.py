import pandas as pd

# taxonomy_file = "test_files/test_kraken1.tsv"
# new_taxonomy_file = "test_files/rewritten_test_kraken1.tsv"
#
# taxonomy_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
#
# taxonomy_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
# new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# #
taxonomy_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
new_taxonomy_file = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"


# Read the file
df = pd.read_csv(taxonomy_file, sep="\s+", engine="python")

# Fill empty spaces with zeros
df = df.fillna(0)

# Convert only the numeric columns to integers
for col in df.columns:
    if df[col].dtype != object:  # Check if the column is not object type (strings)
        df[col] = df[col].astype(int)

# Write the modified DataFrame to a new file
df.to_csv(new_taxonomy_file, sep="\t", index=False)

'''
python histograms/organisms/rewrite_tax_files.py
'''