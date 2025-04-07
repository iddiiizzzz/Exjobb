
import pandas as pd


input_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"
df = pd.read_csv(input_file, sep="\t")  
print("reading done")

# Extract the first 20 rows and 10 columns
df_subset = df.iloc[:20, :10]
print("extracted")

output_file = "test_files/count_matrix_ww1.csv"
df_subset.to_csv(output_file, index=False, sep="\t") 


# /storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv", # skapa testfiler
#     "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"