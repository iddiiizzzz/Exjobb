
import pandas as pd


# Read the original file (adjust the file path and format if necessary)
input_file = '/storage/bergid/blast/scov_pident_filtered_blast.txt'  # Replace with your file's path
df = pd.read_csv(input_file, sep="\t")  # Use sep="\t" for tab-separated files
print("reading done")
# Extract the first 100 rows and 50 columns
df_subset = df.iloc[:100,]
print("extracted")
# Write the subset to a new test file
output_file = 'test_files/test_blast_filtered.txt'  # Path to save the extracted file
df_subset.to_csv(output_file, index=False, sep="\t")  # Use index=True to keep the row names
