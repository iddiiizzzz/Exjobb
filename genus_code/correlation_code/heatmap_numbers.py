import pandas as pd


# all 
# correlation_matrix= "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_status.tsv"
# results = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_all_appearences.tsv"

## ww
# correlation_matrix = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_ww_status.tsv"
# results = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_ww_appearences.tsv"

## hg
correlation_matrix = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_hg_status.tsv"
results = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_hg_appearences.tsv"




df = pd.read_csv(correlation_matrix, sep = "\t")

gene_numbers = df["Gene"].value_counts()
org_numbers = df["Organism"].value_counts()

gene_appearences = df["Gene"].map(gene_numbers)
org_appearences = df["Organism"].map(org_numbers)

df["Appearances"] = gene_appearences.astype(str) + "," + org_appearences.astype(str)


print("write")
df.to_csv(results, sep = "\t", index = False)