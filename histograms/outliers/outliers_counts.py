
"""
    Counts the sum of count values for each organism or sample in a counts matrix and checks each individual count against 
    its repective total value, and saves it in a list.

    Input:
        - count_matrix: Path to the count matrix of interest.

    Output:
        - outliers: Path to the outputfile that stores the outlier sample names, taxid and proportions.

    Notes:
        - Change the out commented files depending on which data set to examine.
        - Change the out commented code snippets depending on if the data looks at rows (organisms) or columns (samples).

"""


import pandas as pd


# Genes
# count_matrix = "/storage/koningen/count_matrix.tsv"
# outliers = "/storage/bergid/outliers/outliers_gene"


# Organisms
count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
#count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
#count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"


# outliers = "/storage/bergid/outliers/outliers_in_samples_hg.tsv"
# outliers = "/storage/bergid/outliers/outliers_in_samples_ww1.tsv"
# outliers = "/storage/bergid/outliers/outliers_in_samples_ww2.tsv"

#outliers = "/storage/bergid/outliers/outliers_in_orgs_hg.tsv"
#outliers = "/storage/bergid/outliers/outliers_in_orgs_ww1.tsv"
#outliers = "/storage/bergid/outliers/outliers_in_orgs_ww2.tsv"

outliers = "/storage/bergid/outliers/unfiltered_outliers_in_orgs_hg.tsv"






# # Outliers in each sample

# # Read the data with 'TrueID' as the index
# data = pd.read_csv(count_matrix, sep='\t', index_col='TrueID')

# # Transpose the data
# data_transposed = data.transpose()

# # Open output file
# with open(outliers, "w") as outfile:
#     for index, row in data_transposed.iterrows():
#         print(f"Processing sample {index}")  # `index` is the original row name before transposition

#         row_sum = row.sum()

#         if row_sum > 0:  
#             for column, value in row.items():
#                 count_proportion = value / row_sum

#                 if count_proportion > 0.1:
#                     outfile.write(f"{index}\t{column}\t{count_proportion}\n")


# ------------------------------------------------------------------------------------------------------------------------


# outliers in each individual

with open(count_matrix, "r") as infile, open(outliers, "w") as outfile:
    header = next(infile).strip().split("\t")
    
    for index, line in enumerate(infile):
        print(f"Processing row {index}")

        columns = line.strip().split("\t") 
        identifier = columns[0]  # Sample name 
        numeric_values = list(map(int, columns[1:]))  
        
        row_sum = sum(numeric_values)

        if row_sum > 0:
            for col_name, value in zip(header[1:], numeric_values):  # Match values with column names
                count_proportion = value / row_sum

                # if count_proportion > 0.1:
                outfile.write(f"{col_name}\t{identifier}\t{count_proportion}\n")

