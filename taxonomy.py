import csv
import re

kraken_file = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"
genome_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
genes_in_original_hosts = "genes_in_original_hosts.tsv" #"/storage/koningen/genes_in_original_hosts.tsv"
taxonomy_of_present_bacteria = "taxonomy_of_present_bacteria.tsv"

with open(kraken_file, "r") as csvfile:
    reader = csv.reader(csvfile)
    header = next(reader)
    cleaned_header = [re.sub(r"\s*\(taxid\s\d+\)", "", col) for col in header]


    with open(genome_taxonomy, "r") as infile, open(taxonomy_of_present_bacteria, "w") as outfile:
        for row in csvfile:
            row = row.strip()
            name = cleaned_header[row]

            if name in genome_taxonomy:
                present_bacteria = outfile.write(name + "\n")


