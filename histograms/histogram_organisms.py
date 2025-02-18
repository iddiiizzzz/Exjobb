import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# organisms = [
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv", 
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
# ]

# all_values = []  # Start as an empty list

# for i in organisms:  
#     df = pd.read_csv(i, sep="\t").iloc[:, 1:]
#     df = df.fillna(0)  # Replace NaNs with 0
#     all_values.extend(df.values.flatten())  # Convert DataFrame values to list

file_path = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"


df = pd.read_csv(file_path, sep="\t").iloc[:, 1:]
df = df.fillna(0)
all_values = df.values.flatten().astype(int)

# Debugging: Check min and max values
print(f"Min count: {all_values.min()}, Max count: {all_values.max()}")
print(f"Total values: {len(all_values)}")

# Create the histogram
plt.figure(figsize=(8, 5))
plt.hist(all_values, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("Count Value")
plt.ylabel("Number of Counts")
plt.title("Histogram of Count Matrix Values")
plt.xticks(range(min(50, all_values.max() + 1)))# Ensure discrete values on x-axis
plt.savefig("histograms/bilder/histogram_ww1.png")
