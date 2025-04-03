import pandas as pd

correlation = "/storage/bergid/correlation/both/correlation_filtered.tsv"
correlation_fixed = "/storage/bergid/correlation/both/final_correlation_filtered.tsv"

df = pd.read_csv(correlation, delimiter = "\t")

print(f"Before: {df.shape[0]} rows")
df.drop_duplicates(inplace=True)
print(f"After: {df.shape[0]} rows")

df.to_csv(correlation_fixed, sep="\t", index=False)

