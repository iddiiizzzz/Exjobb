files = [
    "/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna",
    "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv",
    #"/storage/shared/data_for_master_students/ida_and_ellen/genome_filepaths.tsv",
    #"/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv",
    #"/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"
]

file = "/storage/shared/data_for_master_students/ida_and_ellen/count_matrix.tsv" #/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna"
with open(file, "r") as f:
    for i, line in enumerate(f):
        if i == 1000:  # Stop after 5 rows
            break
        first_column = line.split("\t")[0]  # Split by tab and get the first column
        print(first_column)

