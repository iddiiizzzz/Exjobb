input_file = "/storage/koningen/antibiotic_resistance_genes.fna"
output_file = "shorter_id.fna"

with open(input_file, "r") as infile, open(output_file, "w") as outfile:
    count = 1
    for line in infile:
        if line.startswith(">"):
            # Replace the long identifier with a short one
            outfile.write(f">seq{count}\n")
            count += 1
        else:
            outfile.write(line)