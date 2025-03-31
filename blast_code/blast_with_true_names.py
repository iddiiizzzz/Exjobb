import pandas as pd

ARG_names = "/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna"
blast_results = "/storage/bergid/blast/scov_pident_filtered_blast.txt"
results = "/storage/bergid/blast/blast_final.txt"

seq_ids = []
with open(ARG_names, "r") as infile:
    for line in infile:
        print(f"Loop1: {line}")
        line = line.strip()  
        if line.startswith(">"):  # If it's a sequence identifier
            seq_id = line[1:]  # Remove the ">" at the start
            seq_ids.append(seq_id)  # Store the sequence id

ARG_names_dataframe = pd.DataFrame({"seq_id": seq_ids})
blast_results_dataframe = pd.read_csv(blast_results, sep="\t")

print("hej")

short_name_blast = blast_results_dataframe["sseqid"]
name_index_column = short_name_blast.str.slice(start=3)
name_index_column = pd.to_numeric(name_index_column, errors='coerce')  # Coerce errors to NaN

print("hello")

blast_results_dataframe["True_gene_names"] = name_index_column.map(lambda x: ARG_names_dataframe["seq_id"].iloc[x] if pd.notna(x) and x < len(ARG_names_dataframe) else None)

print("hi")

blast_results_dataframe.to_csv(results, sep="\t", index=False)