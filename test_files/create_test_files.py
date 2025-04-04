
import pandas as pd


input_file = "/storage/koningen/final_count_matrix_orgs.tsv"
df = pd.read_csv(input_file, sep="\t")  
print("reading done")

# Extract the first 20 rows and 10 columns
df_subset = df.iloc[:20, :10]
print("extracted")

output_file = 'test_files/final_count_matrix_orgs.tsv'
df_subset.to_csv(output_file, index=False, sep="\t") 
