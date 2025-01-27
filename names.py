import pandas as pd

ARG_names = "/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna"
blast_results = "blast_results.txt" #"/storage/bergid/blast_results.txt"

seq_ids = []
with open(ARG_names, "r") as infile:
    for line in infile:
        line = line.strip()  # Remove any leading/trailing spaces or newlines
        if line.startswith(">"):  # If it's a sequence identifier
            seq_id = line[1:]  # Remove the ">" at the start
            seq_ids.append(seq_id)  # Store the sequence id

ARG_names_dataframe = pd.DataFrame({"seq_id": seq_ids})
blast_results_dataframe = pd.read_csv(blast_results, sep="\t")

short_name_blast = blast_results_dataframe["sseqid"]
name_index_column = short_name_blast.str.slice(start=3)
name_index_column = pd.to_numeric(name_index_column, errors='coerce')  # Coerce errors to NaN

blast_results_dataframe["True gene names"] = name_index_column.map(lambda x: ARG_names_dataframe["seq_id"].iloc[x] if pd.notna(x) and x < len(ARG_names_dataframe) else None)
#['GCA_016702415.1_ASM1670241v1_JADJEA010000001.1_seq1@@@aph6', 'GCA_000300175.1_ASM30017v1_CP003873.1_seq1@@@class_B_3', 'GCA_026627245.1_ASM2662724v1_JAPNLO010000045.1_seq1@@@aac3_class2', 'GCA_018883945.1_ASM1888394v1_JAHLFF010000111.1_seq1@@@class_D_2', 'CTX-M-151', 'GCA_004796535.1_ASM479653v1_SPHY01000007.1_seq1@@@class_B_1_2', 'GCA_022690625.1_ASM2269062v1_JALCZH010000001.1_seq1@@@class_A', 'GCA_001663155.1_ASM166315v1_CP015963.1_seq2@@@class_A', 'GCA_030159935.1_ASM3015993v1_BSNJ01000001.1_seq1@@@class_B_1_2', 'GCA_022921115.1_ASM2292111v1_CP095075.1_seq1@@@aph6']

#print(blast_results_dataframe.head(10))

##################################################
##################################################

count_matrix = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv"
filtered_count_matrix = "filtered_count_matrix.tsv" #/storage/koningen/filtered_count_matrix.tsv

blast_with_true_names = blast_results_dataframe["True gene names"].dropna().tolist()
matching_lines = []
normalized_blast_genes = []
genes_in_count_matrix = []

for gene in blast_with_true_names:
    gene = gene.strip()  # Strip extra spaces
    rows_blast = gene.split("\t")  # Split the gene into separate elements (if it's a tab-separated list)

    # Apply normalization on each part of the gene (if multiple parts exist after split)
    normalized_blast_genes = [part.replace("(", ".").replace(")", ".").replace("'", ".").replace("-", ".").replace("@", ".") for part in rows_blast]



with open(count_matrix, "r") as infile, open(filtered_count_matrix, "w") as outfile:
        for line in infile:
            line = line.strip()
            genes_in_count_matrix = line.split("\t")[0]
            if genes_in_count_matrix in normalized_blast_genes:
                outfile.write(line + "\n")

#GCA_004458765.1_ASM445876v1_SPJX01000184.1_seq1...aac3_class1
#  ['seq7214', 'seq4532', 'SEQ23811', 'SEQ17183', 'seq88', 'SEQ19131', 'seq5019', 'seq4751', 'SEQ23527', 'seq6846']
# GCA_015477235.1_ASM1547723v1_JADLRP010000005.1_seq1...class_A 
# GCA_016702415.1_ASM1670241v1_JADJEA010000001.1_seq1@@@aph6

# GCA_000300175.1_ASM30017v1_CP003873.1_seq1@@@class_B_3
# GCA_030316925.1_ASM3031692v1_JASZYP010000015.1_seq1...class_B_3
