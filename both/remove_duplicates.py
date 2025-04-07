import pandas as pd

# with_duplicates = "/storage/bergid/correlation/both/correlation_filtered.tsv"
# without_duplicates = "/storage/bergid/correlation/both/final_correlation_filtered.tsv"


with_duplicates = [
    "/storage/koningen/genus/humangut_taxid_to_names.tsv",
    "/storage/koningen/genus/wastewater1_taxid_to_names.tsv",
    "/storage/koningen/genus/wastewater2_taxid_to_names.tsv"
]

without_duplicates = [
    "/storage/koningen/genus/humangut_taxid_to_names_without_duplicates.tsv",
    "/storage/koningen/genus/wastewater1_taxid_to_names_without_duplicates.tsv",
    "/storage/koningen/genus/wastewater2_taxid_to_names_without_duplicates.tsv"
]

for i in range(3):
    df = pd.read_csv(with_duplicates[i], delimiter = "\t", header = None)

    print(f"Before: {df.shape[0]} rows")
    df.drop_duplicates(inplace=True)
    print(f"After: {df.shape[0]} rows")

    df.to_csv(without_duplicates[i], sep="\t", index=False, header = False)

