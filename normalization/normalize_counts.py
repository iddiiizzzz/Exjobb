
import pandas as pd

# count_matrix = "/home/bergid/Exjobb/test_files/final_count_matrix_orgs.tsv"
# normalized_count_matrix = "test_files/normalized_counts.tsv"


# Species
# count_matrix = "/storage/koningen/final_count_matrix_orgs.tsv"
# summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_orgs.tsv"

# count_matrix = "/storage/koningen/final_count_matrix_orgs_ww.tsv"
# summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_orgs_ww.tsv"

# count_matrix = "/storage/koningen/final_count_matrix_orgs_hg.tsv"
# summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_orgs_hg.tsv"

# # # Genes with species
# count_matrix = "/storage/koningen/final_count_matrix_genes_ww.tsv"
# summed_sample_counts = "/storage/bergid/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_genes_ww.tsv"

# count_matrix = "/storage/koningen/final_count_matrix_genes_hg.tsv"
# summed_sample_counts = "/storage/bergid/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_genes_hg.tsv"

# count_matrix = "/storage/koningen/final_count_matrix_genes.tsv"
# summed_sample_counts = "/storage/bergid/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_genes.tsv"


# # Genus
# count_matrix = "/storage/koningen/genus/final_count_matrix_orgs.tsv"
# summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalized_final_count_matrix_orgs.tsv"

# count_matrix = "/storage/koningen/genus/final_count_matrix_orgs_ww.tsv"
# summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalized_final_count_matrix_orgs_ww.tsv"

# count_matrix = "/storage/koningen/genus/final_count_matrix_orgs_hg.tsv"
# summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalized_final_count_matrix_orgs_hg.tsv"

# # Genes with genus
# count_matrix = "/storage/koningen/genus/final_count_matrix_genes_ww.tsv"
# summed_sample_counts = "/storage/bergid/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalized_final_count_matrix_genes_ww.tsv"

# count_matrix = "/storage/koningen/genus/final_count_matrix_genes_hg.tsv"
# summed_sample_counts = "/storage/bergid/normalisation_dictionary_genes.tsv"
# normalized_count_matrix = "/storage/koningen/genus/normalized_final_count_matrix_genes_hg.tsv"

count_matrix = "/storage/koningen/genus/final_count_matrix_genes.tsv"
summed_sample_counts = "/storage/bergid/normalisation_dictionary_genes.tsv"
normalized_count_matrix = "/storage/koningen/genus/normalized_final_count_matrix_genes.tsv"




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
