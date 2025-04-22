
"""
    Filters the count matrices for genes and organisms to only keep the samples that exists in both files.

    Input:
        - genes_infile: Path to the file with the count matrix for the genes.
        - orgs_outfile: Path to the file with the counts matrix for the organisms.

    Output:
        - genes_outfile: Path to the output file stores the sample filtered count matrix for the genes.
        - orgs_outfile: Path to the output file stores the sample filtered count matrix for the organisms.

    Notes:
        - For running multiple files, add the for loop and indent the rest of the code.

"""

import pandas as pd

## Names of organisms (genus)
# with_duplicates = [
#     "/storage/koningen/genus/taxonomy_code/humangut_taxid_to_names.tsv",
#     "/storage/koningen/genus/taxonomy_code/wastewater1_taxid_to_names.tsv",
#     "/storage/koningen/genus/taxonomy_code/wastewater2_taxid_to_names.tsv"
# ]
# without_duplicates = [
#     "/storage/koningen/genus/taxonomy_code/humangut_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/genus/taxonomy_code/wastewater1_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/genus/taxonomy_code/wastewater2_taxid_to_names_without_duplicates.tsv"
# ]


## Names of organisms (species)
# with_duplicates = [
#     "/storage/koningen/species/taxonomy_code/humangut_taxid_to_names.tsv",
#     "/storage/koningen/species/taxonomy_code/wastewater1_taxid_to_names.tsv",
#     "/storage/koningen/species/taxonomy_code/wastewater2_taxid_to_names.tsv"
# ]
# without_duplicates = [
#     "/storage/koningen/species/taxonomy_code/humangut_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/species/taxonomy_code/wastewater1_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/species/taxonomy_code/wastewater2_taxid_to_names_without_duplicates.tsv"
# ]



### Correlation weighted
## Normalized
# all (species)
with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all.tsv"
without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_final.tsv"

# #ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_final.tsv"

# #hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_final.tsv"


## Non-normalized
# all (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_final.tsv"

# # ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_final.tsv"

# # hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_final.tsv"



### Correlation filtered
## Normalized
# all (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_final.tsv"

# ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_final.tsv"

# hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_final.tsv"

## Non-normalized
# all (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_all_final.tsv"

# ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_ww_final.tsv"

# hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_hg_final.tsv"




# for i in range(3): 
df = pd.read_csv(with_duplicates, delimiter = "\t", header = None)

print(f"Before: {df.shape[0]} rows")
df.drop_duplicates(inplace=True)
print(f"After: {df.shape[0]} rows")

df.to_csv(without_duplicates, sep="\t", index=False, header = False)

