

# -------------------------------------------------------------------------------
# Create a new count matrix with only the relevant organisms
# -------------------------------------------------------------------------------


import pandas as pd

filtered_taxids_paths = [
    "/storage/koningen/species/bacteria_final_hg.tsv",
    "/storage/koningen/species/bacteria_final_ww1.tsv",
    "/storage/koningen/species/bacteria_final_ww2.tsv"
    ]
taxonomy_files = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
]

filtered_tax_count_paths = [
    "/storage/koningen/species/filtered_tax_counts_hg.tsv",
    "/storage/koningen/species/filtered_tax_counts_ww1.tsv",
    "/storage/koningen/species/filtered_tax_counts_ww2.tsv"
]


for i in range(3):

    kraken_with_zeros = pd.read_csv(taxonomy_files[i], sep="\s+", engine="python")
    kraken_with_zeros = kraken_with_zeros.fillna(0)

    filtered_taxids = []
    filtered_names = []

    with open(filtered_taxids_paths[i], "r") as file:
        for line in file:
            taxid, name = line.strip().split(maxsplit=1)  # Split taxid and name
            filtered_taxids.append(taxid.strip())  # Add stripped taxid to the list
            filtered_names.append(name.strip())


    columns_to_keep = ["TrueID"]
    

    for column in kraken_with_zeros.columns:
        print(i)
        print(column)
        for taxid in filtered_taxids:
            if column == taxid:
                columns_to_keep.append(column)
                break # break when match found

  
    filtered_df = kraken_with_zeros[columns_to_keep]
    header_df = pd.read_csv(filtered_taxids_paths[i], sep="\t", header=None)
    new_header = header_df.iloc[:,1].tolist()
    filtered_df.columns = new_header
    filtered_df.to_csv(filtered_tax_count_paths[i], sep="\t", index=False, header=True)


