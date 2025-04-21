
import pandas as pd

# count_matrix = "/home/bergid/Exjobb/test_files/final_count_matrix_orgs.tsv"
# normalized_count_matrix = "test_files/normalized_counts.tsv"


## Species all organisms
count_matrix = "/storage/koningen/species/combined_matrices/taxonomy_all_organisms.tsv"
summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
normalized_count_matrix = "/storage/koningen/species/normalize/normalized_count_matrix_all_orgs.tsv"

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

## Genus hg genes
# count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_hg_genes_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_hg_genes.tsv"


## Genus ww organisms
# count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_organisms_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/v/normalize/normalized_count_matrix_ww.tsv"

## Genus ww genes
# count_matrix = "/storage/koningen/genus/filter_zeros/taxonomy_all_ww_genes_filtered.tsv"
# summed_sample_counts = "/storage/bergid/dictionaries/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalize/normalized_count_matrix_ww_genes.tsv"





count_matrix_df = pd.read_csv(count_matrix, sep="\t")
summed_sample_counts_df = pd.read_csv(summed_sample_counts, sep = "\t")


summed_sample_counts_df.set_index("Sample", inplace=True)
normalized_count = count_matrix_df.copy()

for sample in count_matrix_df.columns[1:]:
    print(sample)
    if sample in summed_sample_counts_df.index:
        total_count = summed_sample_counts_df.loc[sample, "Counts"]

        normalized_count[sample] = count_matrix_df[sample] / total_count
    
print("hej")

normalized_count.to_csv(normalized_count_matrix, sep="\t", index=False)
