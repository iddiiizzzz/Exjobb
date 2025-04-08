from collections import defaultdict

ncbi_file = "/storage/koningen/ncbi_taxonomy/assembly_summary.txt"
genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"

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
# output_files = [
#     "/storage/koningen/humangut/humangut_names.tsv",
#     "/storage/koningen/wastewater1/wastewater1_names.tsv",
#     "/storage/koningen/wastewater2/wastewater2_names.tsv"
# ]

# count_matrix = [
#     "test_files/count_matrix_hg.csv",
#     "test_files/count_matrix_ww1.tsv",
#     "test_files/count_matrix_ww2.tsv"
# ]

# output_files = [
#     "test_files/taxid_to_name_hg.tsv",
#     "test_files/taxid_to_name_ww1.tsv",
#     "test_files/taxid_to_name_ww2.tsv"
# ]

print("dictionary 1")
ncbi_dictionary = defaultdict(list) 
with open(ncbi_file, "r") as conversion:
    next(conversion)
    for row in conversion:
        row = row.strip().split("\t")
        assembly_accession = row[0] # The type of id in the taxonomy lineage file
        taxid = row[5] # The type of id in countmatrix
        ncbi_dictionary[taxid].append(assembly_accession)  # Store multiple values


print("dictionary 2")
tax_dictionary = {}
with open(genome_taxonomy, "r") as taxonomy:
    for row in taxonomy:
        row = row.strip().split("\t")
        assembly_id = row[0] # The id in the taxonomy lineage file
        species_name = row[7] # The species name of the organism
        # genus_name = row[6] # The genus name of the organism

        # if species_name == "":
        #     org_name = genus_name
        # else:
        org_name = species_name

        tax_dictionary[assembly_id] = org_name 





for i in range(3):
    
    with open(count_matrix[i], 'r') as infile, open(output_files[i], 'w') as outfile:
        header = infile.readline().strip()

        for taxid in header.split("\t")[1:]:
            print(taxid)
            assembly_ids = ncbi_dictionary.get(taxid, [])
            for assembly_id in assembly_ids:
                org_name = tax_dictionary.get(assembly_id, "Unknown organism name")
                if org_name != "NA":
                    outfile.write(f"{taxid}\t{org_name}\n")

