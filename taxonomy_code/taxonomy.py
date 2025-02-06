import pandas as pd
import re

# Define the file paths
names_file_path = "/storage/koningen/nbci_taxonomy/names.dmp"
kraken_file_path = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"#"test_files/test_kraken.csv" #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"
output_file_path = "/storage/koningen/translated_names.tsv" #"blast_code/blast_outputs/translated_names.tsv"


# Read the names.dmp file with the correct separator (tab-pipe-tab)
names_df = pd.read_csv(names_file_path, sep=r'\t\|\t', header=None, names=['taxid', 'name', 'unique_name', 'name_class'], engine='python')
# Clean up any extra whitespace or tabs
names_df = names_df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)
# Clean up the 'name_class' column by stripping any extra characters
names_df['name_class'] = names_df['name_class'].str.replace(r'\t\|$', '', regex=True)

# Extract taxids from the Kraken file
taxids = []
with open(kraken_file_path, 'r') as file:
    # Read each line and extract all taxids using a regular expression
    for line in file:
        # Find all occurrences of taxids in the form of (taxid <number>)
        matches = re.findall(r'\(taxid (\d+)\)', line)
        taxids.extend([int(match) for match in matches])  # Append all found taxids


# Initialize an empty DataFrame to store the results
all_results = pd.DataFrame(columns=['taxid', 'name'])

# Process each taxid and get the scientific name
for taxid in taxids:
    print(taxid)
    filtered_names = names_df[(names_df['taxid'] == taxid) & (names_df['name_class'] == 'scientific name')]
    result = filtered_names[['taxid', 'name']]

    if not result.empty:
        all_results = pd.concat([all_results, result], ignore_index=True)

    if not all_results.empty:
        all_results.to_csv(output_file_path, index=False, header=True)



######## filter out viruses and other things that are not in the relevant set of genomes ###########
full_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
out = "storage/koningen/bacteria.tsv" #"taxonomy_code/taxonomy_outputs/bacteria.tsv"

# Load all lines of full_taxonomy for searching
with open(full_taxonomy, "r") as tax_file:
    taxonomy_lines = tax_file.readlines()  # Read all lines into a list

# Open the output file for filtered results
with open(output_file_path, "r") as infile, open(out, "w") as outfile:
    for line in infile:
        print(line)
        line = line.strip()  # Remove leading/trailing whitespace
        taxid, name = line.split(",")  # Split taxid and name
        
        # Check if the name appears in any line of the taxonomy file
        if any(name in taxonomy_line for taxonomy_line in taxonomy_lines):
            outfile.write(line + "\n")

