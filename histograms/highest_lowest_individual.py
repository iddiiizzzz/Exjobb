
"""
    Finds the N genes or organisms with the highest and lowest individual counts in the count matrix.

    Input:
        - count_matrix: Path to the count matrix that is examined.

    Output:
        - highest_individual_counts: Path to the outfile that stores a new count matrix with only the genes or 
          organisms that had the highest individual counts.
        - lowest_individual_counts: Path to the outfile that stores a new count matrix with only the genes or 
          organisms that had the lowest individual counts.

    Notes:
        - Changes to do between finding highest and lowest counts:
            - Change the outputfile.
            - Change "extreme_value" to min or max.
            - Change to True or False in sort.
"""



import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# # Genes
# count_matrix = "/storage/koningen/count_matrix.tsv"
# # highest_individual_counts = "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_gene.tsv"
# lowest_individual_counts = "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_gene.tsv"


# Organisms
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv"

# highest_individual_counts = "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_org_hg.tsv"
# highest_individual_counts = "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_org_ww.tsv"

# lowest_individual_counts = "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_org_hg.tsv"
lowest_individual_counts = "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_org_ww.tsv"




num_top_rows = 1
max_zero_percentage = 0.75

values = []
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
        #    extreme_value = max(numeric_values)  
           extreme_value = min(numeric_values) 
           values.append((identifier, extreme_value))  


values.sort(key=lambda x: x[1], reverse=False) # True is descending, highest to lowest

top_identifiers = {identifier for identifier, _ in values[:num_top_rows]}

# with open(count_matrix, "r") as infile, open(highest_individual_counts, "w") as outfile:
with open(count_matrix, "r") as infile, open(lowest_individual_counts, "w") as outfile:
    header = next(infile)  
    outfile.write(header)

    for line in infile:
        columns = line.strip().split("\t")
        identifier = columns[0]  

        if identifier in top_identifiers:  
            outfile.write(line) 

