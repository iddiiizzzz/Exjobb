
# python histograms/organisms/histogram_sum_org.py

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# count_matrix = "/storage/koningen/count_matrix.tsv"

# count_matrix = [
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv", 
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
# ]
count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"
sample_sums_ww1 = "/storage/bergid/sample_sums_ww1.tsv"

sums = []
with open(count_matrix, "r") as infile, open(sample_sums_ww1, "w") as outfile:
    header = next(infile)  # Skip the header line
    outfile.write("Sample\tSum\n") # new header to outfile"
    
    for line in infile:
        columns = line.strip().split("\t")  # Split line into columns
        samples = columns[0]  # First column is sampless
        numeric_values = [int(x) if x.strip() else 0 for x in columns[1:]]  # Replace empty values with 0
  # Convert remaining columns to integers

        row_sum = sum(numeric_values)  # Sum the values
        sums.append((samples, row_sum))  # Store as tuple (samples, sum)

        outfile.write(f"{samples}\t{row_sum}\n")

# df = pd.read_csv(sums, sep="\t").iloc[:, 1:] 
# df = df.fillna(0)

# all_values = df.values.flatten()

# Randomly sample 10% of the values
# sample_size = int(0.01 * len(all_values))  
# random_sample = np.random.choice(all_values, sample_size, replace=False)

# # Plot histogram
# plt.figure(figsize=(8, 5))
# plt.hist(random_sample, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
# plt.xlabel("Count Value")
# plt.ylabel("Frequency")
# plt.title("Histogram of Count Matrix Values for Genes")
# plt.xticks(range(int(all_values.max()) + 1))  # Ensure discrete values on x-axis
# plt.xlim([1,50])
# plt.ylim([0,200000])
# plt.savefig("histograms/bilder/organisms_all/histogram_org_all.png")  

