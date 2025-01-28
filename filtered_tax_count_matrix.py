import pandas as pd
import re
import csv

filtered_taxid = "filtered_taxid.tsv"
kraken_file_path = "test_kraken_counts.csv" #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"
filtered_tax_count = "filtered_tax_count.csv"

filtered_taxids = set()
with open(filtered_taxid, "r") as file:
        for line in file:
            line = line.strip()  # Remove leading/trailing whitespace
            taxid, name = line.split(",")  # Split taxid and name
            filtered_taxids.add(taxid)

with open(kraken_file_path,"r") as infile, open(filtered_tax_count, "w") as outfile:
    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    header = next(reader)

    tax_id_header = []
    for column in header:
         matches = re.findall(r'\(taxid (\d+)\)', column)
         for match in matches:
              tax_id_header.append(match)


    matching_columns = []

    for row in reader:
         # Check if any tax ID in the filtered list matches a column tax ID
        for index, taxid in enumerate(tax_id_header):
             if taxid in filtered_taxids:
                  matching_columns.append(index)

    # If there's a match, write the entire row to the output file
    if matching_columns:
        writer.writerow(row)
        

