import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os

organisms = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv", 
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
]

all_values = []

for i in organisms:  # i is the file path string
    df = pd.read_csv(i, sep="\t").iloc[:, 1:]
    df = df.fillna(0)
    all_values.extend(df.values.flatten())
    print(i)

# Convert list to NumPy array for calculations
all_values = np.array(all_values, dtype=int)

print(f"Number of values: {len(all_values)}")
print(f"Number of bins: {(all_values.max() + 2) - 0.5}")

# Create histogram
plt.figure(figsize=(8, 5))
plt.hist(all_values, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("Count Value")
plt.ylabel("Number of counts")
plt.title("Histogram of Count Matrix Values for all organisms")
plt.xticks(range(min(50, all_values.max() + 1)))  # Ensure discrete x-axis values
plt.xlim([1,50])
plt.savefig("histograms/bilder/organisms_all/histogram_organisms.png")
