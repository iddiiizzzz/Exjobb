import pandas as pd

taxonomy_lineage = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
dictionary = "/storage/bergid/dictionaries/assembly_accession_to_org_names.tsv"


with open(taxonomy_lineage, "r") as taxonomy, open(dictionary, "w") as outfile:
    for row in taxonomy:
        print(row)
        row = row.strip().split("\t")
        assembly_id = row[0] # The type of id in the taxonomy lineage file
        species_name = row[7] # The species name of the organism
        genus_name = row[6] # The genus name of the organism

        if species_name == "":
            org_name = genus_name
        else:
            org_name = species_name

        
        outfile.write(f"{assembly_id}\t{org_name}\n")



