
"""
    Sums all count values in a sample and stores it in a list with their respective sample names.

    Input:
        - count_matrix: Path to the count matrix for the genes.

    Output:
        - normalization_dictionary: Path to the output file with the summed count list.

    Notes:
        - This only needs to be done for the genes, the organisms had a complete list aldready.
"""


import pandas as pd

count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv"
normalization_dictionary = "/storage/bergid/normalisation_dictionary_genes.tsv"

summed_counts = []
sample_names = []

count_matrix_df = pd.read_csv(count_matrix, sep="\t")

for col in count_matrix_df.columns[1:]:
    sample_names.append(col)
    summed_counts.append(count_matrix_df[col].sum())


summary_df = pd.DataFrame({
    "Sample": sample_names,
    "Counts": summed_counts
})

summary_df.to_csv(normalization_dictionary, sep="\t", index=False)

