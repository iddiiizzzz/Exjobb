
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


# Correlation weighted
# with_duplicates = "/storage/bergid/correlation/both/correlation_zinb_weighted.tsv"
# without_duplicates = "/storage/bergid/correlation/both/final_correlation_weighted.tsv"


# Correlation filtered
with_duplicates = "/storage/bergid/correlation/both/correlation_filtered.tsv"
without_duplicates = "/storage/bergid/correlation/both/final_correlation_filtered.tsv"


'''
remove? -------------------------
'''
# Names of organisms
# with_duplicates =[
#     "/storage/koningen/humangut/humangut_names.tsv",
#     "/storage/koningen/wastewater1/wastewater1_names.tsv",
#     "/storage/koningen/wastewater2/wastewater2_names.tsv"
# ]
# without_duplicates = [
#     "/storage/koningen/humangut/humangut_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/wastewater1/wastewater1_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/wastewater2/wastewater2_taxid_to_names_without_duplicates.tsv"
# ]

# Names of organisms
# with_duplicates = [
#     "/storage/koningen/genus/humangut_taxid_to_names.tsv",
#     "/storage/koningen/genus/wastewater1_taxid_to_names.tsv",
#     "/storage/koningen/genus/wastewater2_taxid_to_names.tsv"
# ]
# without_duplicates = [
#     "/storage/koningen/genus/humangut_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/genus/wastewater1_taxid_to_names_without_duplicates.tsv",
#     "/storage/koningen/genus/wastewater2_taxid_to_names_without_duplicates.tsv"
# ]


'''
remove? ---------------------
'''
# with_duplicates = "/storage/bergid/filtered_taxids_felsok.tsv"
# without_duplicates = "/storage/bergid/filtered_taxids_felsok_utan_duplicates.tsv"



# for i in range(3): 
df = pd.read_csv(with_duplicates, delimiter = "\t", header = None)

print(f"Before: {df.shape[0]} rows")
df.drop_duplicates(inplace=True)
print(f"After: {df.shape[0]} rows")

df.to_csv(without_duplicates, sep="\t", index=False, header = False)

