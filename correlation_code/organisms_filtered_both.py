
import numpy as np

count_matrix_ww1 = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
count_matrix_ww2 = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
count_matrix_hg = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"

results = "/storage/bergid/correlation/results_org_correlation_all_log_sep75.tsv"

with open(count_matrix, "r") as infile, open(count_matrix_ww1, "r") as infile_ww1, open(count_matrix_ww2, "r") as infile_ww2, open(count_matrix_hg, "r") as infile_hg, open(results, "w") as outfile:
    next(infile), next(infile_ww1), next(infile_ww2), next(infile_hg)

    for line in infile:
        columns = line.strip().split("\t")
        taxid = columns[0]
        values = np.array(columns[1:], dtype=float)

        
import pandas as pd

# Function to read and filter data
def read_and_filter(file):
    # Read the data
    data = pd.read_csv(file, sep='\t')
    # Set the TrueID as the index
    data.set_index('TrueID', inplace=True)
    # Filter rows where more than 75% of the columns have zero values
    filtered_data = data[(data == 0).sum(axis=1) / data.shape[1] < 0.75]
    # Return the index (organism names) of the filtered data
    return filtered_data.index

# Filter each file separately
org_names_ww1 = read_and_filter(count_matrix_ww1)
org_names_ww2 = read_and_filter(count_matrix_ww2)
org_names_hg = read_and_filter(count_matrix_hg)

