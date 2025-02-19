import pandas as pd

taxonomy_file = "test_files/test_kraken1.tsv"
new_taxonomy_file = "test_files/rewritten_test_kraken1.tsv"

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