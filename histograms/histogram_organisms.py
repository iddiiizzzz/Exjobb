import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv

organisms1 = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.csv"
organisms2 = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.csv"
organisms3 = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
new_organisms1 = "/storage/bergid/taxonomy_rewrites/taxonomy_wastewater_rewrite1.csv"
new_organisms2 = "/storage/bergid/taxonomy_rewrites/taxonomy_wastewater_rewrite2.csv"
new_organisms3 = "/storage/bergid/taxonomy_rewrites/taxonomy_human_gut_rewrite.csv"

with open(organisms1, 'r') as infile1, open(organisms2, 'r') as infile2, open(organisms3, 'r') as infile3:
    with open(new_organisms1, 'w') as outfile1, open(new_organisms2, 'w') as outfile2, open(new_organisms3, 'w') as outfile3:
        reader1 = csv.reader(infile1)
        reader2 = csv.reader(infile2)
        reader3 = csv.reader(infile3)
        writer1 = csv.writer(outfile1)
        writer2 = csv.writer(outfile2)
        writer3 = csv.writer(outfile3)

        next(reader1)  # Skip header
        next(reader2)  # Skip header
        next(reader3)  # Skip header

        for row in reader1:
            writer1.writerow(row[2:])  # Skip first two columns and write the rest

        for row in reader2:
            writer2.writerow(row[2:])  # Skip first two columns and write the rest

        for row in reader3:
            writer3.writerow(row[2:]) 

# Load the data, skipping the header row and excluding the first two columns
df1 = pd.read_csv(new_organisms1, sep=",").fillna(0)
df2 = pd.read_csv(new_organisms2, sep=",").fillna(0)
df3 = pd.read_csv(new_organisms3, sep=",").fillna(0)

all_values1 = df1.values.flatten().astype(float)
all_values2 = df2.values.flatten().astype(float)
all_values3 = df3.values.flatten().astype(float)

all_values = np.concatenate([all_values1, all_values2, all_values3])

# Plot histogram
plt.figure(figsize=(8, 5))
plt.hist(all_values, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("Count Value")
plt.ylabel("Frequency")
plt.title("Histogram of Count Matrix Values for Organisms")
plt.xticks(range(int(all_values.max()) + 1))  # Ensure discrete values on x-axis
plt.xlim([1, 100])
plt.ylim([0, 50000])
plt.savefig("histograms/bilder/histogram_organisms.png")
