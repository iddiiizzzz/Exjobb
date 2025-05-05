import pandas as pd


latent_list = "/storage/bergid/dictionaries/args_latent_established.tsv"


### Correlation weighted
## Normalized
# all 
# correlation_list = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_status.tsv"

# ww
# correlation_list = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_status.tsv"

# hg
# correlation_list = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_status.tsv"


## Non-normalized
# all 
# correlation_list = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_status.tsv"

# ww
# correlation_list = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_status.tsv"

#hg
# correlation_list = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_status.tsv"



### Correlation filtered
## Normalized
# all 
# correlation_list = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_status.tsv"

# ww
# correlation_list = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_status.tsv"

# hg
# correlation_list = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_status.tsv"


## Non-normalized
# all 
# correlation_list = "/storage/bergid/correlation/species/both/correlation_filtered_all_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/correlation_filtered_all_status.tsv"

# ww
# correlation_list = "/storage/bergid/correlation/species/both/correlation_filtered_ww_sorted.tsv"
# results = "/storage/bergid/correlation/species/both/correlation_filtered_ww_status.tsv"

#hg
correlation_list = "/storage/bergid/correlation/species/both/correlation_filtered_hg_sorted.tsv"
results = "/storage/bergid/correlation/species/both/correlation_filtered_hg_status.tsv"



print("dictionary")
latent_dictionary = {}
with open(latent_list, "r") as dict:
    next(dict)
    for row in dict:
        row = row.strip().split("\t")
        name = row[0]
        status = row[1]
        latent_dictionary[name] = status


print("loop")
status_list = []
with open(correlation_list, "r") as corr:
    next(corr)
    for line in corr:
        line = line.strip().split()
        gene_name = line[0]
        status_gene = latent_dictionary.get(gene_name)
        status_list.append(status_gene)

df = pd.read_csv(correlation_list, sep = "\t")
df["Gene status"] = status_list

print("write")
df.to_csv(results, sep = "\t", index = False)