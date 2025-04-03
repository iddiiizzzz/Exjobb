import pandas as pd

ncbi_file = "/storage/koningen/ncbi_taxonomy/assembly_summary.txt"
genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
assembly_dictionary = "/storage/bergid/dictionaries/taxid_to_assembly_accession.tsv"
name_dictionary = "/storage/bergid/dictionaries/assembly_accession_to_org_names.tsv"

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




with open(assembly_dictionary, "r") as assembly_dict, open(name_dictionary, "r") as name_dict:
    for i in range(3):
        with open(count_matrix[i], 'r') as infile, open(output_files[i], 'w') as outfile:
            header = infile.readline().strip()
            for taxid in header.split()[1:]:
                print(i)
                print(taxid)
                taxid = int(taxid.strip())


                if taxid in assembly_dict[0]:
                    if assembly_dict[1] in name_dictionary[0]:
                        org_name = name_dictionary[1]
                    else:
                        org_name = "Unknown organism name"

                else:
                    org_name = "Unknown assembly accession"
                    
                    
                outfile.write(f"{taxid}\t{org_name}\n")




