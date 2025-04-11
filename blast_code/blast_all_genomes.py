
"""
    Runs a BLASTN search of genome sequences against an ARG database.

    Input:
        - paths_to_genomes: Path to a file containing genome file paths.
        - database: Path to a BLASTN-formatted database of ARGs.

    Output:
        - output_file: Path to the final output file that will store all BLAST results table.

    Requires:
        - NCBI BLAST+ installed and accessible via the `blastn` command.
"""



import gzip 
import os
import subprocess

paths_to_genomes = "/storage/shared/data_for_master_students/ida_and_ellen/genome_filepaths.tsv" 
database = "/storage/bergid/data_base/antibiotic_resistance_db"
output_file = "/storage/bergid/blast/blast_results.txt"

with open(output_file, "w") as outfile:
    # Header to output file
    outfile.write("qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tslen\tscov\n")

with open(paths_to_genomes, "r") as file:
    for line in file:
        print(line)
        zipped_file_paths = line.strip()

        if zipped_file_paths.endswith(".gz"):
            unzipped_file_paths = "/storage/bergid/unzipped_files/{}".format(os.path.basename(zipped_file_paths[:-3]))


            with gzip.open(zipped_file_paths, "rb") as zipped_file:
                with open(unzipped_file_paths,"wb") as unzipped_file:
                    unzipped_file.write(zipped_file.read())

        temporary_output_file = "/storage/bergid/temp_blast_output.txt"
        result = [
                "blastn", 
                "-query", unzipped_file_paths, 
                "-db", database, 
                "-out", temporary_output_file, 
                "-outfmt", "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen",  # 6 = Tabular format, 7 = with header
                "-num_threads", "40"
                ]
        subprocess.call(result)


        with open(temporary_output_file, "r") as infile, open(output_file, 'a') as outfile:
            for line in infile:
                fields = line.strip().split("\t")
                alignment_length = abs(float(fields[7]) - float(fields[6])) + 1 # Alignment length ***WRONG***
                subject_length = float(fields[12])  # Subject length (slen)
                scov = (alignment_length / subject_length) * 100
                
                outfile.write("\t".join(fields[:13]) + "\t{:.2f}\n".format(scov))
                
                
        os.remove(temporary_output_file) 

