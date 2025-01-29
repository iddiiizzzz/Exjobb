import pandas as pd

ARG_names = "/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna"
blast_results = "/blast_code/blast_outputs/blast_results.txt" #"/storage/bergid/blast_results.txt"

seq_ids = []
with open(ARG_names, "r") as infile:
    for line in infile:
        line = line.strip()  
        if line.startswith(">"):  # If it's a sequence identifier
            seq_id = line[1:]  # Remove the ">" at the start
            seq_ids.append(seq_id)  # Store the sequence id

ARG_names_dataframe = pd.DataFrame({"seq_id": seq_ids})
blast_results_dataframe = pd.read_csv(blast_results, sep="\t")

short_name_blast = blast_results_dataframe["sseqid"]
name_index_column = short_name_blast.str.slice(start=3)
name_index_column = pd.to_numeric(name_index_column, errors='coerce')  # Coerce errors to NaN

blast_results_dataframe["True gene names"] = name_index_column.map(lambda x: ARG_names_dataframe["seq_id"].iloc[x] if pd.notna(x) and x < len(ARG_names_dataframe) else None)

#print(blast_results_dataframe.head(10))

##################################################
##################################################

count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv"
filtered_count_matrix = "/blast_code/blast_outputs/filtered_count_matrix.tsv" #/storage/koningen/filtered_count_matrix.tsv

blast_with_true_names = blast_results_dataframe["True gene names"].dropna().tolist()
normalized_blast_genes = []

for gene in blast_with_true_names:
    gene = gene.strip() 

    normalized_genes = gene.replace("(", ".").replace(")", ".").replace("'", ".").replace("-", ".").replace("@", ".")
    normalized_blast_genes.append(normalized_genes)


with open(count_matrix, "r") as infile, open(filtered_count_matrix, "w") as outfile:
    header = infile.readline().strip()  # Read and keep the header
    outfile.write(header + "\n")
    
    for line in infile:
        line = line.strip()
        genes_in_count_matrix = line.split("\t")[0]
        if genes_in_count_matrix in normalized_blast_genes:
            outfile.write(line + "\n")

