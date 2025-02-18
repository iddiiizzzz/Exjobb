import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

count_matrix = "/storage/koningen/count_matrix.tsv"
# highest_raw_counts = "/storage/koningen/ranked_counts/highest_raw_counts.tsv"
lowest_raw_counts = "/storage/koningen/ranked_counts/lowest_raw_counts.tsv"

num_top_rows = 1
max_zero_percentage = 0.75

values = []
with open(count_matrix, "r") as infile:
    next(infile)  # Skip the header line
    
    for line in infile:
        columns = line.strip().split("\t")  # Split line into columns
        identifier = columns[0]  # First column is identifiers
        numeric_values = list(map(int, columns[1:]))  # Convert remaining columns to integers
        
        # Calculate the number of zeroes in the row
        num_zeroes = numeric_values.count(0)
        zero_percentage = num_zeroes / len(numeric_values)

        # Only include rows with more than 75% non-zero
        if zero_percentage <= max_zero_percentage:
           #max_value = max(numeric_values)  # Find the maximum value in the row
           max_value = min(numeric_values) # Find the minimum value in the row
           values.append((identifier, max_value))  # Store as tuple (identifier, max_value)

# Sort
values.sort(key=lambda x: x[1], reverse=False) # High to low --> True

# Get the top N identifiers based on the highest individual values
top_identifiers = {identifier for identifier, _ in values[:num_top_rows]}

# Filter the original file to keep only the rows with identifiers in the selected list
with open(count_matrix, "r") as infile, open(lowest_raw_counts, "w") as outfile:
    header = next(infile)  # Read and write the header
    outfile.write(header)

    for line in infile:
        columns = line.strip().split("\t")
        identifier = columns[0]  # First column (identifier)

        if identifier in top_identifiers:  # Check if identifier is in the selected list
            outfile.write(line)  # Write the matching rows to the new file


### Histogram #####
df = pd.read_csv(lowest_raw_counts, sep="\t").iloc[:, 1:] 
all_values = df.values.flatten()

# Apply transformation
all_values = np.sqrt(all_values )

# Plot histogram
plt.figure(figsize=(8, 5))
plt.hist(all_values, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("SquareRoot-transformed Count Value")
plt.ylabel("Number of counts")
plt.title(f"SquareRoot-transformed counts for the gene with the highest individual value")
plt.xticks(range(int(all_values.max()) + 1))  # Ensure discrete values on x-axis
plt.savefig("histograms/bilder/one_gene_histograms/histogram_1gene_highest_individual_sqrt.png")
