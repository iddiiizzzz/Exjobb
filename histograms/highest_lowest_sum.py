
# --------------------------------------------------------------------
# Finding the N genes with the highest and lowest summed counts
# --------------------------------------------------------------------

'''
Changes for switching between highest or lowest:
- Output file
- True/False in sort
'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Genes
count_matrix = "/storage/koningen/count_matrix.tsv"
highest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_gene.tsv"
# lowest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_gene.tsv"


# Organisms
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"

# highest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_org_hg.tsv"
# highest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_org_ww1.tsv"
# highest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_org_ww2.tsv"

# lowest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_hg.tsv"
# lowest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_ww1.tsv"
# lowest_sum_counts = "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_ww2.tsv"




num_top_rows = 1
max_zero_percentage = 0.75

sums = []
with open(count_matrix, "r") as infile:
    next(infile)  
    
    for line in infile:
        columns = line.strip().split("\t") 
        identifier = columns[0]  
        numeric_values = list(map(int, columns[1:]))  

        # Calculate the number of zeroes in the row
        num_zeroes = numeric_values.count(0)
        zero_percentage = num_zeroes / len(numeric_values)

        # Only include rows with more than 75% non-zero
        if zero_percentage <= max_zero_percentage:
            row_sum = sum(numeric_values)  
            sums.append((identifier, row_sum)) 


sums.sort(key=lambda x: x[1], reverse=True)  # True is descending, highest to lowest

top_identifiers = {identifier for identifier, _ in sums[:num_top_rows]}

with open(count_matrix, "r") as infile, open(highest_sum_counts, "w") as outfile:
    header = next(infile)  
    outfile.write(header)

    for line in infile:
        columns = line.strip().split("\t")
        identifier = columns[0]  

        if identifier in top_identifiers:  
            outfile.write(line)