
"""
    Translates the sequence IDs of ARGs back to their original names, normalises the names from unnecessary 
    characters and stores them as a new column in the BLAST results table.

    Input:
        - ARG_names: Path to a file containing genome file paths.
        - blast_results: Path to the filtered BLAST results.

    Output:
        - results: Path to the output file that will store the extended BLAST results table.

"""


import pandas as pd

ARG_names = "/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna"
blast_results = "/storage/bergid/blast/scov_pident_filtered_blast.txt"
results = "/storage/bergid/blast/blast_gene_names.txt"

# blast_results = "test_files/test_blast_filtered.txt"
# results = "test_files/test_blast_gene_names.txt"

seq_ids = []
with open(ARG_names, "r") as infile:
    for line in infile:
        line = line.strip()  
        if line.startswith(">"):  
            seq_id = line[1:]  # Remove the ">" at the start
            seq_ids.append(seq_id)  

ARG_names_dataframe = pd.DataFrame({"seq_id": seq_ids})

normalized_blast_genes = []
for gene in ARG_names_dataframe["seq_id"]:
    gene = gene.strip() 

    normalized_genes = gene.replace("(", ".").replace(")", ".").replace("'", ".").replace("-", ".").replace("@", ".")
    normalized_blast_genes.append(normalized_genes)


normalized_blast_genes_df = pd.DataFrame({"seq_id": normalized_blast_genes})
blast_results_dataframe = pd.read_csv(blast_results, sep="\t")


short_name_blast = blast_results_dataframe["sseqid"]
name_index_column = short_name_blast.str.slice(start=3)
name_index_column = pd.to_numeric(name_index_column, errors='coerce')  # Coerce errors to NaN


blast_results_dataframe["True_gene_names"] = name_index_column.map(lambda x: normalized_blast_genes_df["seq_id"].iloc[x] if pd.notna(x) and x < len(normalized_blast_genes_df) else "Gene name not detected")
blast_results_dataframe.to_csv(results, sep="\t", index=False)