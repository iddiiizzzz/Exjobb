
# -------------------------------------------------------------------
# Finding the N genes with the highest and lowest individual count
# -------------------------------------------------------------------

'''
Changes for switching between highest or lowest:
- Output file
- "extreme_value" = min/max
- True/False in sort
'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

count_matrix = "/storage/koningen/count_matrix.tsv"

# Gene counts
# highest_raw_counts = "/storage/koningen/ranked_counts/highest_raw_counts_gene.tsv"
lowest_raw_counts = "/storage/koningen/ranked_counts/lowest_raw_counts_gene.tsv"




num_top_rows = 1
max_zero_percentage = 0.75

values = []
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
        #    extreme_value = max(numeric_values)  # Find the maximum value in the row
           extreme_value = min(numeric_values) # Find the minimum value in the row
           values.append((identifier, extreme_value))  


values.sort(key=lambda x: x[1], reverse=False) # True is descending, highest to lowest

top_identifiers = {identifier for identifier, _ in values[:num_top_rows]}

with open(count_matrix, "r") as infile, open(lowest_raw_counts, "w") as outfile:
    header = next(infile)  
    outfile.write(header)

    for line in infile:
        columns = line.strip().split("\t")
        identifier = columns[0]  

        if identifier in top_identifiers:  
            outfile.write(line) 

