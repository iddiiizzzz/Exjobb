
"""
    Filters the BLAST results table to keep matches with sequence coverage above 70% and identity above 90%.

    Input:
        - blast: Path to the BLAST results with corrected alignment lengths.

    Output:
        - filtered_blast: Path to the output file that will store the filtered BLAST results table.

"""

blast = "/storage/bergid/blast/blast_results_corrected.txt" 
filtered_blast = "/storage/bergid/blast/scov_pident_filtered_blast.txt"


with open(blast, "r") as infile, open(filtered_blast, "w") as outfile:
    header = infile.readline().strip()
    outfile.write(header + "\n")

    for line in infile:
        print(line)
        next(infile)
        fields = line.strip().split("\t")

        identity = float(fields[2])
        scov = float(fields[13])
        if scov > 70 and identity > 90:
            outfile.write("\t".join(fields[:13]) + "\t{:.2f}\n".format(scov))

