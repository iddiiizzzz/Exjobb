import pandas as pd


genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
blast_results = "/storage/bergid/blast/blast_gene_names.txt"
results = "/storage/bergid/blast/blast_final.txt"

# blast_results = "test_files/test_blast_filtered.txt"
# results = "test_files/blast_org_names.txt"

tax_dictionary = {}
with open(genome_taxonomy, "r") as taxonomy:
    for row in taxonomy:
            print(f"Loop1: {row}")
            row = row.strip().split("\t")
            genome_id = row[0]
            genome_name = row[7]
            tax_dictionary[genome_id] = genome_name



genome_names = []
with open(blast_results, "r") as blast:
    next(blast)
    for line in blast:
        print(f"Loop2: {line}")
        line = line.strip().split("\t")
        genome_id = line[0]
        genome_names.append(tax_dictionary.get(genome_id))


blast_results_dataframe = pd.read_csv(blast_results, sep="\t")
# print(blast_results_dataframe)
# print(genome_names)
blast_results_dataframe["Org_names"] = genome_names


blast_results_dataframe.to_csv(results, sep="\t", index=False)