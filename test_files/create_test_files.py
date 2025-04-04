
import pandas as pd


input_file = "/storage/bergid/blast/blast_final.txt"
df = pd.read_csv(input_file, sep="\t")  
print("reading done")

# Extract the first 20 rows and 10 columns
df_subset = df.iloc[:50,]
print("extracted")

output_file = 'test_files/blast_final.tsv'
df_subset.to_csv(output_file, index=False, sep="\t") 
