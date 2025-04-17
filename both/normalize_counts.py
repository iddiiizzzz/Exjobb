
import pandas as pd

# count_matrix = "/home/bergid/Exjobb/test_files/final_count_matrix_orgs.tsv"
# normalized_count_matrix = "test_files/normalized_counts.tsv"

count_matrix = "/storage/koningen/final_count_matrix_orgs.tsv"
summed_sample_counts = "/storage/bergid/bacterial_counts.tsv"
normalized_count_matrix = "/storage/koningen/normalized_final_count_matrix_orgs.tsv"


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
