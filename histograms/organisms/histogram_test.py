
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# count_matrix = "/storage/koningen/count_matrix.tsv"

# count_matrix = [
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv", 
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv"
# ]
# count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"

count_matrix = "test_files/rewritten_test_kraken1.tsv"

df = pd.read_csv(count_matrix, sep="\t").iloc[:, 1:] 
all_values = df.values.flatten()

# Plot histogram
plt.figure(figsize=(8, 5))
plt.hist(all_values, bins=np.arange(all_values.max() + 2) - 0.5, edgecolor='black')
plt.xlabel("Count Value")
plt.ylabel("Number of counts")
plt.title("Histogram of Count Matrix Values for Organisms")
plt.xticks(range(int(all_values.max()) + 1))  # Ensure discrete values on x-axis
# plt.xlim([1,50])
# plt.ylim([0,200000])
plt.savefig("histograms/bilder/organisms_all/histogram_org_all.png")  

'''
python histograms/organisms/histogram_test.py
'''