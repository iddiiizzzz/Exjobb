import csv
import pandas as pd
filtered_taxid = "taxonomy_code/taxonomy_outputs/bacteria_species_only.tsv"  # taxid + relevant names
kraken_file_path = "test_files/test_kraken.tsv"  # Path to Kraken file
filtered_tax_count = "taxonomy_code/taxonomy_outputs/filtered_tax_count.tsv"  # Output file

kraken_with_zeros = pd.read_csv(kraken_file_path, sep="\s+", engine="python")
kraken_with_zeros = kraken_with_zeros.fillna(0)
print(kraken_with_zeros)

# filtered_taxids = []
# with open(filtered_taxid, "r") as file:
#     for line in file:
#         line = line.strip()
#         taxid, name = line.split(maxsplit=1)  # Split taxid and name
#         filtered_taxids.append(taxid.strip())  # Add stripped taxid to the list

# print("Filtered TaxIDs:", filtered_taxids)  # Print filtered taxids

# with open(kraken_file_path, "r") as infile, open(filtered_tax_count, "w") as outfile:
#      reader = csv.reader(infile, delimiter='\t')
#      writer = csv.writer(outfile, delimiter='\t')

#      header_line = next(infile)
#      header = header_line.strip().split()
#      print("Header:", header)  # Print header

#      keep_indices = [0]  # Keeps the first column

#      # Find column indices to keep
#      for i, taxid in enumerate(header):
#           if taxid.strip() in filtered_taxids:  # Match stripped taxid
#                keep_indices.append(i)

#      print("Keep Indices:", keep_indices)  # Print indices of columns to keep

#      filtered_header = []

#      # Write the new header row (keeping the sample names and filtered taxids)
#      for i in keep_indices:
#           filtered_header.append(header[i])  # Append only the columns we want to keep
#      writer.writerow(filtered_header)

#      # Reinitialize the csv reader to process the data rows
#      infile.seek(0)
#      reader = csv.reader(infile, delimiter='\t')
#      next(reader)  # Skip the header line

#      # Process the rest of the file
#      for row in reader:
#           filtered_row = []
#           for i in keep_indices:
#                filtered_row.append(row[i])  # Append the corresponding value to filtered_row
#           writer.writerow(filtered_row)
