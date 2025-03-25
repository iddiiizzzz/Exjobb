
filtered_count_matrix = "blast_code/blast_outputs/filtered_count_matrix.tsv" #"/storage/koningen/filtered_count_matrix.tsv"
genes_in_original_hosts = "blast_code/blast_outputs/genes_in_original_hosts.tsv" #"/storage/koningen/genes_in_original_hosts.tsv"

with open(filtered_count_matrix, "r") as infile, open(genes_in_original_hosts, "w") as outfile:
    header = infile.readline().strip()
    outfile.write(header + "\n")
    for line in infile:
        columns = line.strip().split("\t")
        
        count_values = [int(value) for value in columns[1:]]

        if any(0 < count_value <= 20 for count_value in count_values) and all(count_value <= 20 for count_value in count_values):
            outfile.write("\t".join(columns) + "\n")
                

# relevant ens?