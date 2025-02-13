import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv"
df = pd.read_csv(count_matrix, sep="\t", skiprows=1).iloc[:, 1:] 

all_values = df.values.flatten()

# # Randomly sample 10% of the values
# sample_size = int(0.1 * len(all_values))  
# random_sample = np.random.choice(all_values, sample_size, replace=False)

# Plot histogram
plt.figure(figsize=(8, 5))
plt.hist(all_values, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("Count Value")
plt.ylabel("Frequency")
plt.title("Histogram of Count Matrix Values for Genes")
plt.xticks(range(int(all_values.max()) + 1))  # Ensure discrete values on x-axis
plt.xlim([1,50])
plt.ylim([0,200000])
plt.savefig("histograms/bilder/genes_all/histogram_genes.png")  

