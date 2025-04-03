import pandas as pd


genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
id_conversion = "/storage/shared/data_for_master_students/ida_and_ellen/id_conversion_table.tsv"

# blast_results = "test_files/test_blast_gene_names.txt"
# results = "test_files/blast_org_names.txt"


# taxonomy_files = [
#     "test_files/test_kraken1.csv",
#     "test_files/test_kraken2.tsv",
#     "test_files/test_kraken3.tsv"
# ]
# output_files = [
#     "test_files/taxid_to_names11.tsv",
#     "test_files/taxid_to_names2.tsv",
#     "test_files/taxid_to_names3.tsv"
# ]

taxonomy_files = [
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_human_gut.csv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_1.tsv",
    "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_wastewater_2.tsv"
]
output_files = [
    "/storage/koningen/genus/humangut_taxid_to_names.tsv",
    "/storage/koningen/genus/wastewater1_taxid_to_names.tsv",
    "/storage/koningen/genus/wastewater2_taxid_to_names.tsv"
]



conversion_dictionary = {}
with open(id_conversion, "r") as conversion:
    next(conversion)
    for row in conversion:
        print(f"dictionary 1: {row}")
        row = row.strip().split("\t")
        assembly = row[0] # The id in the taxonomy lineage file
        blast_id = row[1] # The id in the blast result file
        conversion_dictionary[blast_id] = assembly


tax_dictionary = {}
with open(genome_taxonomy, "r") as taxonomy:
    for row in taxonomy:
        print(f"dictionary 2: {row}")
        row = row.strip().split("\t")
        assembly_id = row[0] # The id in the taxonomy lineage file
        species_name = row[7] # The species name of the organism
        genus_name = row[6] # The genus name of the organism

        if species_name == "":
            org_name = genus_name
        else:
            org_name = species_name

        tax_dictionary[assembly_id] = org_name 



for i in range(3):
    
    with open(taxonomy_files[i], 'r') as infile, open(output_files[i], 'w') as outfile:
        header = infile.readline().strip()
        wierd_ids = []
        for taxid in header.split()[1:]:
            print(i)
            print(taxid)
            taxid = int(taxid.strip())
            wierd_id = conversion_dictionary.get(taxid, "Unkown ID")
            org_names = tax_dictionary.get(wierd_id, "Unknown organism name")

            outfile.write(f"{taxid}\t{org_names}\n")


