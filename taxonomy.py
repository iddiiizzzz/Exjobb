
import pandas as pd
import re

# Function to load and process the names.dmp file
def load_taxonomy_names(file_path):
    # Read the names.dmp file with the correct separator (tab-pipe-tab)
    names_df = pd.read_csv(file_path, sep=r'\t\|\t', header=None, names=['taxid', 'name', 'unique_name', 'name_class'], engine='python')

    # Clean up any extra whitespace or tabs
    names_df = names_df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)

    # Clean up the 'name_class' column by stripping any extra characters
    names_df['name_class'] = names_df['name_class'].str.replace(r'\t\|$', '', regex=True)

    return names_df

# Function to extract only scientific names for a specific tax ID
def get_scientific_name_for_taxid(names_df, taxid):
    # Filter the DataFrame for the specific tax ID and name_class = 'scientific name'
    filtered_names = names_df[(names_df['taxid'] == taxid) & (names_df['name_class'] == 'scientific name')]
    return filtered_names[['taxid', 'name']]

# Function to write the result to a CSV file
def write_result_to_csv(result, output_file_path):
    if not result.empty:
        result.to_csv(output_file_path, index=False, header=True)

# Function to extract taxids from the Kraken file
def extract_taxids_from_file(file_path):
    taxids = []
    with open(file_path, 'r') as file:
        # Read each line and extract all taxids using a regular expression
        for line in file:
            # Find all occurrences of taxids in the form of (taxid <number>)
            matches = re.findall(r'\(taxid (\d+)\)', line)
            taxids.extend([int(match) for match in matches])  # Append all found taxids
    return taxids

# Main script
if __name__ == "__main__":
    # Define the file paths
    names_file_path = "/storage/koningen/nbci_taxonomy/names.dmp"
    kraken_file_path = "test_kraken.csv" #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"
    output_file_path = "count_matrix_found_bacteria.tsv"

    # Load the names data
    names_df = load_taxonomy_names(names_file_path)

    # Extract taxids from the Kraken file
    taxids = extract_taxids_from_file(kraken_file_path)

    # Initialize an empty DataFrame to store the results
    all_results = pd.DataFrame(columns=['taxid', 'name'])

    # Process each taxid and get the scientific name
    for taxid in taxids:
        result = get_scientific_name_for_taxid(names_df, taxid)
        if not result.empty:
            all_results = pd.concat([all_results, result], ignore_index=True)

    # Write the results to a CSV file
    write_result_to_csv(all_results, output_file_path)



######## filter out viruses and other things that are not in the relevant set of genomes ###########
full_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
out = "filtered_taxid.tsv"

# Load all lines of full_taxonomy for searching
with open(full_taxonomy, "r") as tax_file:
    taxonomy_lines = tax_file.readlines()  # Read all lines into a list

# Open the output file for filtered results
with open(output_file_path, "r") as infile, open(out, "w") as outfile:
    for line in infile:
        line = line.strip()  # Remove leading/trailing whitespace
        taxid, name = line.split(",")  # Split taxid and name
        
        # Check if the name appears in any line of the taxonomy file
        if any(name in taxonomy_line for taxonomy_line in taxonomy_lines):
            outfile.write(line + "\n")

