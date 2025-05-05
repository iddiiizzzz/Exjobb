
"""
    Normalizes the count valuies in the count matrices by dividing them of the total count values for the sample.

    Input:
        - count_matrix: Path to the count matrix that should be normalized.
        - summed_sample_counts: Path to a list of all samples and their total count value.

    Output:
        - normalized_count_matrix: Path to the output file with the normalized count matrix.

    Notes:
        - Change the out commented file paths depending on which files to normalize.
"""


import pandas as pd
import numpy as np

# count_matrix = "/home/bergid/Exjobb/test_files/final_count_matrix_orgs.tsv"
# normalized_count_matrix = "test_files/normalized_counts.tsv"


## Species all organisms
# count_matrix = "/storage/koningen/species/combined_matrices/taxonomy_all_organisms.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_all_orgs.tsv"

## Species all genes
# count_matrix = "/storage/koningen/species/combined_matrices/taxonomy_all_genes.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_all_genes.tsv"


## Species hg organisms
# count_matrix = "/storage/koningen/species/filter_zeros/taxonomy_hg_organisms_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries//bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_hg.tsv"

## Species hg genes
# count_matrix = "/storage/koningen/species/filter_zeros/taxonomy_hg_genes_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_hg_genes.tsv"


## Species ww organisms
# count_matrix = "/storage/koningen/species/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_ww.tsv"

## Species ww genes
# count_matrix = "/storage/koningen/species/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_ww_genes.tsv"




## Genus all organisms
# count_matrix = "/storage/koningen/genus/combined_matrices/taxonomy_all_organisms.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_all_orgs.tsv"

## Genus all genes
# count_matrix = "/storage/koningen/genus/combined_matrices/taxonomy_all_genes.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_all_genes.tsv"


## Genus hg organisms
# count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_hg_organisms_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_hg.tsv"

# Genus hg genes
# count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_hg_genes_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_hg_genes.tsv"


## Genus ww organisms
# count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_ww.tsv"

## Genus ww genes
count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"
summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_ww_genes.tsv"





count_matrix_df = pd.read_csv(count_matrix, sep="\t")
summed_sample_counts_df = pd.read_csv(summed_sample_counts, sep = "\t")


summed_sample_counts_df.set_index("Sample", inplace=True)
normalized_count = count_matrix_df.copy()
normalized_count_log = count_matrix_df.copy()

for sample in count_matrix_df.columns[1:]:
    print(sample)
    if sample in summed_sample_counts_df.index:
        total_count = summed_sample_counts_df.loc[sample, "Counts"]

        if total_count == 0 or pd.isnull(total_count):
            normalized_count[sample] = 0

        else:
            normalized_count[sample] = count_matrix_df[sample] / total_count
    

# Convert count values to float to ensure correct data type
normalized_count.iloc[:, 1:] = normalized_count.iloc[:, 1:].astype(float)

# Apply log normalization
normalized_count.iloc[:, 1:] = np.log1p(normalized_count.iloc[:, 1:])

normalized_count.to_csv(normalized_count_matrix, sep="\t", index=False)
print("hey")