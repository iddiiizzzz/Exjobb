

"""
    Finds the N genes or organisms with the highest and lowest mean counts in the count matrix.

    Input:
        - count_matrix: Path to the count matrix that is examined.

    Output:
        - highest_individual_counts: Path to the outfile that stores a new count matrix with only the genes or 
          organisms that had the highest mean counts.
        - lowest_individual_counts: Path to the outfile that stores a new count matrix with only the genes or 
          organisms that had the lowest mean counts.

    Notes:
        - Change input and output files depending on if you want genes or organisms.
        - Changes to do between finding highest and lowest counts:
            - Change the outputfile.
            - Change to True or False in sort.
"""



import numpy as np


# Genes
# count_matrix = "/storage/koningen/count_matrix.tsv"
# highest_mean_counts = "/storage/koningen/ranked_counts/average_counts/highest_average_counts_gene.tsv"
# lowest_mean_counts = "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_gene.tsv"


# Organisms
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv"

# highest_mean_counts = "/storage/koningen/ranked_counts/average_counts/highest_average_counts_org_hg.tsv"
# highest_mean_counts = "/storage/koningen/ranked_counts/average_counts/highest_average_counts_org_ww.tsv"

# lowest_mean_counts = "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_org_hg.tsv"
lowest_mean_counts = "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_org_ww.tsv"



num_top_rows = 1
max_zero_percentage = 0.75

means = []  
with open(count_matrix, "r") as infile:
    next(infile)  
    
    for line in infile:
        columns = line.strip().split("\t")  
        identifier = columns[0]  
        numeric_values = list(map(int, columns[1:]))  


        num_zeroes = numeric_values.count(0)
        zero_percentage = num_zeroes / len(numeric_values)

        # Only include rows with more than 75% non-zero
        if zero_percentage <= max_zero_percentage:
            row_mean = np.mean(numeric_values)  
            means.append((identifier, row_mean)) 


means.sort(key=lambda x: x[1], reverse=False) # True is descending, highest to lowest
top_identifiers = {identifier for identifier, _ in means[:num_top_rows]}


# with open(count_matrix, "r") as infile, open(highest_mean_counts, "w") as outfile:
with open(count_matrix, "r") as infile, open(lowest_mean_counts, "w") as outfile:
    header = next(infile)  
    outfile.write(header)

    for line in infile:
        columns = line.strip().split("\t")
        identifier = columns[0]  

        if identifier in top_identifiers:  
            outfile.write(line)  
