

# -------------------------------------------------------------------------------
# Create a new count matrix with only the relevant organisms
# -------------------------------------------------------------------------------


import pandas as pd

filtered_taxids_paths = [
    "/storage/koningen/humangut/bacteria_species_only_hg.tsv",
    "/storage/koningen/wastewater1/bacteria_species_only_ww1.tsv",
    "/storage/koningen/wastewater2/bacteria_species_only_ww2.tsv"
]

taxonomy_files = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
]

filtered_tax_count_paths = [
    "/storage/koningen/humangut/filtered_tax_counts_hg.tsv",
    "/storage/koningen/wastewater1/filtered_tax_counts_ww1.tsv",
    "/storage/koningen/wastewater2/filtered_tax_counts_ww2.tsv"
]

# taxonomy_files = [
#     "test_files/test_kraken1.csv",
#     "test_files/test_kraken2.tsv",
#     "test_files/test_kraken3.tsv"
# ]

# filtered_taxids_paths = [
#     "test_files/species_filtered_bacteria1.tsv",
#     "test_files/species_filtered_bacteria2.tsv",
#     "test_files/species_filtered_bacteria3.tsv"
# ]
# filtered_tax_count_paths = [
#     "test_files/tax_counts_filtered1.tsv",
#     "test_files/tax_counts_filtered2.tsv",
#     "test_files/tax_counts_filtered3.tsv"
# ]

for i in range(3):

    kraken_with_zeros = pd.read_csv(taxonomy_files[i], sep="\s+", engine="python")
    kraken_with_zeros = kraken_with_zeros.fillna(0)

    filtered_taxids = []
    with open(filtered_taxids_paths[i], "r") as file:
        for line in file:
            taxid, name = line.strip().split(maxsplit=1)  # Split taxid and name
            filtered_taxids.append(taxid.strip())  # Add stripped taxid to the list


    columns_to_keep = ["TrueID"]

    for column in kraken_with_zeros.columns:
        print(column)
        for taxid in filtered_taxids:
            if column == taxid:
                columns_to_keep.append(column)
                break # break when match found

    # New dataframe with only the selected columns
    filtered_df = kraken_with_zeros[columns_to_keep]

    # Save to new file
    filtered_df.to_csv(filtered_tax_count_paths[i], sep="\t", index=False)

