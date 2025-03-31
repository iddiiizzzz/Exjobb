# -------------------------------------------------------------------------------
# Find the names that correspond to each tax ID
# -------------------------------------------------------------------------------

import pandas as pd

names_file_path = "/storage/koningen/nbci_taxonomy/names.dmp"
# taxonomy_files = [
#     "test_files/test_kraken1.csv",
#     "test_files/test_kraken2.tsv",
#     "test_files/test_kraken3.tsv"
# ]
# output_files = [
#     "test_files/taxid_to_names11.tsv",
#     "test_files/taxid_to_names11.tsv",
#     "test_files/taxid_to_names3.tsv"
# ]

taxonomy_files = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
]
output_files = [
    "/storage/koningen/humangut/humangut_names.tsv",
    "/storage/koningen/wastewater1/wastewater1_names.tsv",
    "/storage/koningen/wastewater2/wastewater2_names.tsv"
]

# Read the names.dmp file with the correct separator (tab-pipe-tab)
names_df = pd.read_csv(names_file_path, sep=r'\t\|\t', header=None, 
                        names=['taxid', 'name', 'unique_name', 'name_class'], engine='python')
names_df = names_df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)  # Clean whitespace
names_df['name_class'] = names_df['name_class'].str.replace(r'\t\|$', '', regex=True)

for i in range(3):
    with open(taxonomy_files[i], 'r') as infile:
        header = infile.readline().strip()
        taxids = []
        for taxid in header.split()[1:]:
            taxid = int(taxid.strip())
            taxids.append(taxid)

    with open(output_files[i], 'w', encoding='utf-8') as outfile:
        for taxid in taxids:
            print(f"Processing taxid: {taxid} in loop {i}")
            filtered_names = names_df[(names_df['taxid'] == taxid) & (names_df['name_class'] == 'scientific name')]
            result = filtered_names[['taxid', 'name']]
            result.to_csv(outfile, sep="\t", index=False, header=False, mode='a')
