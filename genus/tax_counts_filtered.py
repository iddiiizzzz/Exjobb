

# -------------------------------------------------------------------------------
# Create a new count matrix with only the relevant organisms
# -------------------------------------------------------------------------------


import pandas as pd

filtered_taxids_paths = [
    "/storage/koningen/genus/bacteria_species_only_hg.tsv",
    "/storage/koningen/genus/bacteria_species_only_ww1.tsv",
    "/storage/koningen/genus/bacteria_species_only_ww2.tsv"
    ]

count_matrix = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
]

filtered_count_matrix = [
    "/storage/koningen/genus/filtered_tax_counts_hg.tsv",
    "/storage/koningen/genus/filtered_tax_counts_ww1.tsv",
    "/storage/koningen/genus/filtered_tax_counts_ww2.tsv"
]

outfile = "/storage/bergid/filtered_taxids_felsok.tsv"
outfile2 = "/storage/bergid/columns_to_keep_felsok.tsv"
for i in range(3):

    kraken_with_zeros = pd.read_csv(count_matrix[i], sep="\s+", engine="python")
    kraken_with_zeros = kraken_with_zeros.fillna(0)

    filtered_taxids = []
    filtered_names = []

    with open(filtered_taxids_paths[i], "r") as file, open(outfile, "w") as out:
        for line in file:
            taxid, name = line.strip().split(maxsplit=1)  # Split taxid and name
            filtered_taxids.append(taxid.strip())  # Add stripped taxid to the list
            filtered_names.append(name.strip())
            out.write(f"{taxid}\n")


    columns_to_keep = ["TrueID"]
    
    with open(outfile2, "w") as out:
        for column in kraken_with_zeros.columns:
            print(i)
            print(column)
            for taxid in filtered_taxids:
                if column == taxid:
                    columns_to_keep.append(column)
                    out.write(f"{taxid}\n")
                    break # break when match found

  
    filtered_df = kraken_with_zeros[columns_to_keep]
    header_df = pd.read_csv(filtered_taxids_paths[i], sep="\t", header=None)
    new_header = header_df.iloc[:,1].tolist()
    filtered_df.columns = new_header
    filtered_df.to_csv(filtered_count_matrix[i], sep="\t", index=False, header=True)


