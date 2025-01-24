import pandas as pd


ARG_names = "/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna"
blast_results = "blast_results.txt" #"/storage/bergid/blast_results.txt"

# Initialize an empty list to store sequence ids
seq_ids = []

# Open the ARG_names (FASTA) file and read it line by line
with open(ARG_names, "r") as infile:
    for line in infile:
        line = line.strip()  # Remove any leading/trailing spaces or newlines
        if line.startswith(">"):  # If it's a sequence identifier
            seq_id = line[1:]  # Remove the ">" at the start
            seq_ids.append(seq_id)  # Store the sequence id

ARG_names_dataframe = pd.DataFrame({"seq_id": seq_id})
blast_results_dataframe = pd.read_csv(blast_results, sep="\t")
#ARG_names_dataframe = pd.read_csv(ARG_names, sep="\t", header=None)

short_name_blast = blast_results_dataframe["sseqid"]
#true_name = ARG_names_dataframe[0]

name_index_column = short_name_blast.str.slice(start=3)
name_index_column = pd.to_numeric(name_index_column, errors='coerce')  # Coerce errors to NaN

#mapping_true_names = true_name.to_dict()

#blast_results_dataframe["True gene names"] = name_index_column.map(lambda x: true_name[x] if pd.notna(x) else None)
blast_results_dataframe["True gene names"] = name_index_column.map(lambda x: ARG_names_dataframe["seq_id"].iloc[x] if pd.notna(x) and x < len(ARG_names_dataframe) else None)

print(blast_results_dataframe.head(10))