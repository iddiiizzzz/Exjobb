import pandas as pd


genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
id_conversion = "/storage/shared/data_for_master_students/ida_and_ellen/id_conversion_table.tsv"
# blast_results = "/storage/bergid/blast/blast_gene_names.txt"
# results = "/storage/bergid/blast/blast_final.txt"

blast_results = "test_files/test_blast_gene_names.txt"
results = "test_files/blast_org_names.txt"



conversion_dictionary = {}
with open(id_conversion, "r") as conversion:
    next(conversion)
    for row in conversion:
        print(f"Loop1: {row}")
        row = row.strip().split("\t")
        assembly = row[0] # The name in the taxonomy lineage file
        blast_id = row[1] # The name in the blast result file
        conversion_dictionary[blast_id] = assembly


tax_dictionary = {}
with open(genome_taxonomy, "r") as taxonomy:
    for row in taxonomy:
        print(f"Loop2: {row}")
        row = row.strip().split("\t")
        assembly_id = row[0] # The name in the taxonomy lineage file
        genome_name = row[7] # The name of the organism
        tax_dictionary[assembly_id] = genome_name 



genome_names = []
with open(blast_results, "r") as blast:
    next(blast)
    for line in blast:
        print(f"Loop3: {line}")
        line = line.strip().split("\t")
        blast_id = line[0]
        assembly_present = conversion_dictionary.get(blast_id)
        genome_names.append(tax_dictionary.get(assembly_present, "Organism name not detected"))





blast_results_dataframe = pd.read_csv(blast_results, sep="\t")
blast_results_dataframe["Org_names"] = genome_names


blast_results_dataframe.to_csv(results, sep="\t", index=False)