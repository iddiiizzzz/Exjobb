
"""
    Translates the organism IDs to their taxonomic genus names and adds them as a new column in the BLAST results table.

    Input:
        - blast: Path to the BLAST results.

    Output:
        - filtered_blast: Path to the output file that will store the filtered BLAST results table.

"""


import pandas as pd


genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
id_conversion = "/storage/shared/data_for_master_students/ida_and_ellen/id_conversion_table.tsv"
blast_results = "/storage/bergid/blast/blast_with_species_names.txt"
results = "/storage/bergid/blast/blast_final.txt"

# blast_results = "test_files/test_blast_gene_names.txt"
# results = "test_files/blast_org_names.txt"


print("Dictionary1")
conversion_dictionary = {}
with open(id_conversion, "r") as conversion:
    next(conversion)
    for row in conversion:
        row = row.strip().split("\t")
        assembly = row[0] # The id in the taxonomy lineage file
        blast_id = row[1] # The id in the blast result file
        conversion_dictionary[blast_id] = assembly

print("Dictionary2")
tax_dictionary = {}
with open(genome_taxonomy, "r") as taxonomy:
    for row in taxonomy:
        row = row.strip().split("\t")
        assembly_id = row[0] # The id in the taxonomy lineage file
        genome_name = row[6] # The genus name of the organism
        tax_dictionary[assembly_id] = genome_name 


print("loop")
genome_names = []
with open(blast_results, "r") as blast:
    next(blast)
    for line in blast:
        line = line.strip().split("\t")
        blast_id = line[0]
        assembly_present = conversion_dictionary.get(blast_id)
        genome_names.append(tax_dictionary.get(assembly_present, "Organism name not detected"))





blast_results_dataframe = pd.read_csv(blast_results, sep="\t")
blast_results_dataframe["Genus_names"] = genome_names


blast_results_dataframe.to_csv(results, sep="\t", index=False)