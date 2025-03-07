input_file = "/storage/bergid/blast/blast_results.txt"
corrected_file = "/storage/bergid/blast/blast_results_corrected.txt"

# input_file = "test_files/test_blast.txt"
# corrected_file = "test_files/test_blast_corrected.txt"

with open(input_file, "r") as infile, open(corrected_file, 'w') as outfile:
    header = infile.readline()  # Read header
    outfile.write(header)  # Write header to new file
    
    for line in infile:
        fields = line.strip().split()
        
        alignment_length = abs(float(fields[9]) - float(fields[8])) + 1 #Alignment length

        length = float(fields[3])
        subject_length = abs(float(fields[9]) - float(fields[8])) + 1  #slen
        query_length = abs(float(fields[7]) - float(fields[6])) + 1  #qlen 
        # print(f"length: {length}")
        # print(f"slen: {subject_length}")
        # print(f"qlen: {query_length}")

        scov = (alignment_length / subject_length) * 100

        outfile.write("\t".join(fields[:13]) + "\t{:.2f}\n".format(scov))
