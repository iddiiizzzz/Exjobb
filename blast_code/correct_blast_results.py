
"""
    Calculates a corrected alignment length from the BLAST results.

    Input:
        - input_file: Path to the BLAST results file.

    Output:
        - corrected_file: Path to the output file with the corrected alignment lengths.

"""


input_file = "/storage/bergid/blast/blast_results.txt"
corrected_file = "/storage/bergid/blast/blast_results_corrected.txt"

# input_file = "test_files/test_blast.txt"
# corrected_file = "test_files/test_blast_corrected.txt"

with open(input_file, "r") as infile, open(corrected_file, 'w') as outfile:
    header = infile.readline()
    outfile.write(header)
    
    for line in infile:
        fields = line.strip().split()
        
        alignment_length = abs(float(fields[9]) - float(fields[8])) + 1 # Alignment length
        subject_length = float(fields[12]) # slen

        scov = (alignment_length / subject_length) * 100

        outfile.write("\t".join(fields[:13]) + "\t{:.2f}\n".format(scov))
