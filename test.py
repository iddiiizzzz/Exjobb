import pandas as pd

file_path = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"

df = pd.read_csv(file_path, nrows=10)

df_columns = df.iloc[:,:3]

print(df_columns)