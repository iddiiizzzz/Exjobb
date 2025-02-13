import pandas as pd
import re
import csv

filtered_taxid = "taxonomy_code/taxonomy_outputs/filtered_bacteria.tsv" # taxid + relevanta namn
kraken_file_path = "test_files/test_kraken_counts.csv" #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"
tax_count = "taxonomy_code/taxonomy_outputs/filtered_tax_count.csv" # outfilefiltered_

filtered_taxids = []
with open(filtered_taxid, "r") as file:
     for line in file:
          line = line.strip()  # Remove leading/trailing whitespace
          taxid, name = line.split(",")  # Split taxid and name
          filtered_taxids.append(taxid)


with open(kraken_file_path,"r") as infile, open(filtered_tax_count, "w") as outfile:
     reader = csv.reader(infile)
     writer = csv.writer(outfile)

     header = next(reader)

     tax_id_header = []
     column_indices = [0] # keeps the first column

     for column in header:
          kraken_taxid = re.findall(r'\(taxid (\d+)\)', column)
          for number in kraken_taxid:
              tax_id_header.append(number)
              


     taxid_saved = []
     for column in range(len(tax_id_header)):
         if tax_id_header[column] in filtered_taxids:
               taxid_saved.append(tax_id_header[column])



     for index, column in enumerate(header):
          kraken_taxid = re.findall(r'\(taxid (\d+)\)', column)
          if kraken_taxid and kraken_taxid[0] in taxid_saved:
               column_indices.append(index)

     filtered_header = []
     for index in column_indices:
          filtered_header.append(header[index])
     writer.writerow(filtered_header)

     # write only the selected columns from each row
     for row in reader:
          filtered_row = []
          for index in column_indices:
               filtered_row.append(row[index])
          writer.writerow(filtered_row)

        