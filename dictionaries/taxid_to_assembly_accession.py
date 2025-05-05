import pandas as pd

ncbi_file = "/storage/koningen/ncbi_taxonomy/assembly_summary.txt"
dictionary = "/storage/bergid/dictionaries/taxid_to_assembly_accession.tsv"



with open(ncbi_file, "r") as conversion, open(dictionary, "w") as outfile:
    next(conversion)
    for row in conversion:
        print(f"dictionary 1: {row}")
        row = row.strip().split("\t")
        assebly_accession = row[0] # The type of id in the taxonomy lineage file
        taxid = row[6] # The type of id in countmatri

        outfile.write(f"{taxid}\t{assebly_accession}\n")



# Remove?