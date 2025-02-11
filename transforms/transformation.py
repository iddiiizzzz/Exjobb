import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math


ARGs = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv"
organisms1 = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.csv"
organisms2 = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.csv"
organisms3 = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"

df = pd.read_csv(ARGs, sep="\t", header=0, index_col=0) 
all_values = df.values.flatten()

transformed_ARGs = np.log(all_values+1)


# # Randomly sample 10% of the values
# sample_size = int(0.1 * len(all_values))  
# random_sample = np.random.choice(transformed_ARGs, sample_size, replace=False)

# Plot histogram
plt.figure(figsize=(8, 5))
plt.hist(transformed_ARGs, bins=np.arange(transformed_ARGs.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("Count Value")
plt.ylabel("Frequency")
plt.title("Histogram of Log-Transformed Count Matrix Values")
plt.xticks(range(int(transformed_ARGs.max()) + 1))  # Ensure discrete values on x-axis
plt.xlim([0,10])
plt.ylim([0,300000])
plt.savefig("histograms/bilder/log_transformed_histogram_genes.png")  

