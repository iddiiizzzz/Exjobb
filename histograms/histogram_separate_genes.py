import pandas as pd

count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv"
highest_raw_counts = "/storage/koningen/ranked_counts/highest_raw_counts.tsv"

# Read the count matrix into a pandas DataFrame
df = pd.read_csv(count_matrix, sep='\t')

# Sum the counts for each row (excluding the first column)
row_sums = df.iloc[:, 1:].sum(axis=1)

# Create a new DataFrame with the first column (gene names) and the row sums
result_df = pd.DataFrame({
    'gene': df.iloc[:, 0],
    'sum': row_sums
})

# Write the resulting DataFrame to a new file
result_df.to_csv(highest_raw_counts, sep='\t', index=False)


# första kolumnen står atm 0 ist för namn, och vi vill endast ta ut de 10 högsta tex