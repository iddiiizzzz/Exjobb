
import pandas as pd


# Read the original file (adjust the file path and format if necessary)
input_file = '/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv'  # Replace with your file's path
df = pd.read_csv(input_file, sep="\t")  # Use sep="\t" for tab-separated files

# Extract the first 100 rows and 50 columns
df_subset = df.iloc[:100, :50]

# Write the subset to a new test file
output_file = '/home/bergid/Exjobb/test_files/test_kraken1.tsv'  # Path to save the extracted file
df_subset.to_csv(output_file, index=False, sep="\t")  # Use index=True to keep the row names
