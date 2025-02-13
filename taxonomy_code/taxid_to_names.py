
# -------------------------------------------------------------------------------
# Find the names that corresponds to each tax ID
# -------------------------------------------------------------------------------

import pandas as pd

names_file_path = "/storage/koningen/nbci_taxonomy/names.dmp"

counts_wastewater1 = "test_files/test_kraken1.tsv" #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv"
counts_wastewater2 = "test_files/test_kraken2.tsv"  #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
counts_humangut = "test_files/test_kraken3.tsv"  #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.tsv"

output_file_path1 = "/storage/koningen/wastewater1/wastewater1_names.tsv" 
output_file_path2 = "/storage/koningen/wastewater2/wastewater2_names.tsv"
output_file_path3 = "/storage/koningen/humangut/humangut_names.tsv"

# Read the names.dmp file with the correct separator (tab-pipe-tab)
names_df = pd.read_csv(names_file_path, sep=r'\t\|\t', header=None, names=['taxid', 'name', 'unique_name', 'name_class'], engine='python')
# Clean up any extra whitespace or tabs
names_df = names_df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)
# Clean up the 'name_class' column by stripping any extra characters
names_df['name_class'] = names_df['name_class'].str.replace(r'\t\|$', '', regex=True)

# Initialize an empty DataFrame to store the results
all_results = pd.DataFrame(columns=['taxid', 'name'])

with open(counts_wastewater1, 'r') as infile1, open(counts_wastewater2, 'r') as infile2, open(counts_humangut) as infile3:
    header1 = infile1.readline().strip()
    header2 = infile2.readline().strip()
    header3 = infile3.readline().strip()

    # Extracting the whole taxID numbers as one unit
    taxids1 = header1.split()[1:] 
    taxids2 = header2.split()[1:]
    taxids3 = header3.split()[1:]

with open(output_file_path1, 'w') as outfile1, open(output_file_path2, 'w') as outfile2, open(output_file_path3, 'w') as outfile3:
# Process each taxid and get the scientific name
    for taxid in taxids1:
        taxid = int(taxid.strip()) # Make them int instead of str and remove whitespace
        print(f"current taxid: {taxid}")
        
        filtered_names = names_df[(names_df['taxid'] == taxid) & (names_df['name_class'] == 'scientific name')]
        result = filtered_names[['taxid', 'name']]
        
        result.to_csv(outfile1, sep="\t", index=False, header=False, mode='a')

    for taxid in taxids2:
        taxid = int(taxid.strip()) # Make them int instead of str and remove whitespace
        print(f"current taxid: {taxid}")
        
        filtered_names = names_df[(names_df['taxid'] == taxid) & (names_df['name_class'] == 'scientific name')]
        result = filtered_names[['taxid', 'name']]
        
        result.to_csv(outfile2, sep="\t", index=False, header=False, mode='a')

    for taxid in taxids3:
        taxid = int(taxid.strip()) # Make them int instead of str and remove whitespace
        print(f"current taxid: {taxid}")
        
        filtered_names = names_df[(names_df['taxid'] == taxid) & (names_df['name_class'] == 'scientific name')]
        result = filtered_names[['taxid', 'name']]
        
        result.to_csv(outfile3, sep="\t", index=False, header=False, mode='a')        







