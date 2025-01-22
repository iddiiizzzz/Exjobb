import gzip 
import os
import subprocess

paths_to_genomes = "exempel_paths.tsv"
database = "/storage/bergid/antibiotic_resistance_db.fna"
output_file = "blast_results.txt"


with open(paths_to_genomes, "r") as file:
    for line in file:
        zipped_file_paths = line.strip()

        if zipped_file_paths.endswith(".gz"):
            unzipped_file_paths = "/storage/bergid/{}".format(os.path.basename(zipped_file_paths[:-3]))


            # with gzip.open(zipped_file_paths, "rb") as zipped_file:
            #     with open(unzipped_file_paths,"wb") as unzipped_file:
            #         unzipped_file.write(zipped_file.read())


        result = [
                "blastn", 
                "-query", unzipped_file_paths, 
                "-db", database, 
                "-out", output_file, 
                # "-outfmt", "6",  # Tabular format
                # "-evalue", "1e-5", 
                "-num_threads", "20"
                ]
        subprocess.call(result)
        # outfile.write(subprocess.call(result))



