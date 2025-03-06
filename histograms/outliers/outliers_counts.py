

# count sum for each individual
# check each count against the sum
# save if higher than 10%


import pandas as pd

# Test
# count_matrix = "test_files/rewritten_test_kraken3.tsv"
# outliers = "test_files/test_outliers.tsv"

# Genes
# count_matrix = "/storage/koningen/count_matrix.tsv"
# outliers = "/storage/bergid/outliers/outliers_gene"
ERR2683205
Enterobacteriaceae - 543
outliers/outliers_in_orgs_hg.tsv

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






# # outliers in each sample

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

