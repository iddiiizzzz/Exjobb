
"""
    Removes rows in the file that are the exact same.

    Input:
        - with_duplicates: Path to the file that contains duplicates of rows.

    Output:
        - without_duplicates: Path to the outputfile that stores the duplicate filtered file.

    Notes:
        - For running multiple files, add the for loop and indent the rest of the code.
        - Switch the out commented files and rows depending on which matrix to filter and transform.

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
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_without_duplicates.tsv"

# #ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_without_duplicates.tsv"

# #hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_without_duplicates.tsv"


## Non-normalized
# all (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_without_duplicates.tsv"

# # ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_without_duplicates.tsv"

# # hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_without_duplicates.tsv"



### Correlation filtered
## Normalized
# all (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_without_duplicates.tsv"

# ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_without_duplicates.tsv"

# hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_without_duplicates.tsv"

## Non-normalized
# all (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_all.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_all_without_duplicates.tsv"  

# # ww (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_ww_without_duplicates.tsv"

# hg (species)
# with_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/species/both/correlation_filtered_hg_without_duplicates.tsv"




# Genus

### Correlation weighted
## Normalized
# all 
with_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted.tsv"
without_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_without_duplicates.tsv"

# #ww 
# with_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_ww_without_duplicates.tsv"

# #hg 
# with_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_zinb_weighted_hg_without_duplicates.tsv"


## Non-normalized
# all 
# with_duplicates = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted.tsv" # ej körd än
# without_duplicates = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_without_duplicates.tsv"

# # ww 
# with_duplicates = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_ww_without_duplicates.tsv"

# # hg 
# with_duplicates = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_hg.tsv"  
# without_duplicates = "/storage/bergid/correlation/genus/both/correlation_zinb_weighted_hg_without_duplicates.tsv"  



### Correlation filtered
## Normalized
# all 
# with_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_filtered.tsv" 
# without_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_filtered_without_duplicates.tsv" 

# ww
# with_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_filtered_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/normalized_correlation_filtered_ww_without_duplicates.tsv"

# hg 
# with_duplicates = "/storage/bergid/correlation/genus/both/noremalized_correlation_filtered_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/noremalized_correlation_filtered_hg_without_duplicates.tsv"

## Non-normalized
# all 
# with_duplicates = "/storage/bergid/correlation/genus/both/correlation_filtered.tsv" 
# without_duplicates = "/storage/bergid/correlation/genus/both/correlation_filtered_without_duplicates.tsv" 

# ww
# with_duplicates = "/storage/bergid/correlation/genus/both/correlation_filtered_ww.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/correlation_filtered_ww_without_duplicates.tsv"

# hg 
# with_duplicates = "/storage/bergid/correlation/genus/both/correlation_filtered_hg.tsv"
# without_duplicates = "/storage/bergid/correlation/genus/both/correlation_filtered_hg_without_duplicates.tsv"




# for i in range(3): 
df = pd.read_csv(with_duplicates, delimiter = "\t", header = None)

print(f"Before: {df.shape[0]} rows")
df.drop_duplicates(subset=[0, 1], inplace=True)  
print(f"After: {df.shape[0]} rows")

df.to_csv(without_duplicates, sep="\t", index=False, header = False)

