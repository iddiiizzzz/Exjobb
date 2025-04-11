
"""
    Translates sequence names of ARGs into shorter IDs.

    Input:
        - input_file: Path to a file containing ARG names and their sequences.

    Output:
        - output_file: Path to the output file that will store the translated IDs and their sequences.

"""



input_file = "/storage/koningen/database/antibiotic_resistance_genes.fna"
output_file = "/storage/koningen/shorter_id.fna"

with open(input_file, "r") as infile, open(output_file, "w") as outfile:
    count = 1
    for line in infile:
        if line.startswith(">"):
            outfile.write(f">seq{count}\n")
            count += 1
        else:
            outfile.write(line)