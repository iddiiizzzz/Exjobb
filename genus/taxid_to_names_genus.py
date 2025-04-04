import pandas as pd

ncbi_file = "/storage/koningen/ncbi_taxonomy/assembly_summary.txt"
genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
ncbi_dict_file = "/storage/bergid/dictionaries/taxid_to_assembly_accession.tsv"
name_dict_file = "/storage/bergid/dictionaries/assembly_accession_to_org_names.tsv"

count_matrix = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
]
output_files = [
    "/storage/koningen/genus/humangut_taxid_to_names.tsv",
    "/storage/koningen/genus/wastewater1_taxid_to_names.tsv",
    "/storage/koningen/genus/wastewater2_taxid_to_names.tsv"
]

print("dictionary 1")
# tar 13 minuter
ncbi_dictionary = {}
with open(ncbi_file, "r") as conversion, open(ncbi_dict_file, "w") as outfile:
    next(conversion)
    for row in conversion:
        # print(f"dictionary 1: {row}")
        row = row.strip().split("\t")
        assembly_accession = row[0] # The type of id in the taxonomy lineage file
        taxid = row[6] # The type of id in countmatrix

        ncbi_dictionary[taxid] = assembly_accession
        outfile.write(f"{taxid}\t{assembly_accession}\n")


print("dictionary 2")
# tar x minuter
tax_dictionary = {}
with open(genome_taxonomy, "r") as taxonomy, open(name_dict_file, "w") as outfile:
    for row in taxonomy:
        # print(f"dictionary 2: {row}")
        row = row.strip().split("\t")
        assembly_id = row[0] # The id in the taxonomy lineage file
        species_name = row[7] # The species name of the organism
        genus_name = row[6] # The genus name of the organism

        if species_name == "":
            org_name = genus_name
        else:
            org_name = species_name

        tax_dictionary[assembly_id] = org_name 
        outfile.write(f"{assembly_id}\t{org_name}\n")



for i in range(3):
    
    with open(count_matrix[i], 'r') as infile, open(output_files[i], 'w') as outfile:
        header = infile.readline().strip()

        for taxid in header.split()[1:]:
            print(taxid)
            assembly_id = ncbi_dictionary.get(taxid, "Unkown ID")
            print(assembly_id)
            org_name = tax_dictionary.get(assembly_id, "Unknown organism name")
            print(org_name)

            outfile.write(f"{taxid}\t{org_name}\n")


