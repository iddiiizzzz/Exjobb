

blast = "/storage/bergid/blast/blast_results.txt"
filtered_blast = "/storage/bergid/blast/filtered_blast.txt"


with open(blast, "r") as infile, open(filtered_blast, "w") as outfile:
    header = infile.readline().strip()
    outfile.write(header + "\n")

    for line in infile:
        next(infile)
        fields = line.strip().split("\t")

        # Filter
        identity = float(fields[2])
        scov = float(fields[13])
        if scov > 70 and identity > 90:
            outfile.write("\t".join(fields[:13]) + "\t{:.2f}\n".format(scov))

