
import pandas as pd


input_file = "/storage/koningen/ncbi_taxonomy/assembly_summary.txt"
df = pd.read_csv(input_file, sep="\t")  
print("reading done")

# Extract the first 20 rows and 10 columns
df_subset = df.iloc[:50, ]
print("extracted")

output_file = "test_files/ncbi_assembly_summary.txt"
df_subset.to_csv(output_file, index=False, sep="\t") 
