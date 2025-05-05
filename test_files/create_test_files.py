
import pandas as pd


input_file = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_status.tsv"
df = pd.read_csv(input_file, sep="\t")  
print("reading done")

# Extract the first 20 rows and 10 columns
df_subset = df.iloc[:10, ]
print("extracted")

output_file = "test_files/normalized_correlation_zinb_weighted_hg_status.tsv"
df_subset.to_csv(output_file, index=False, sep="\t") 
