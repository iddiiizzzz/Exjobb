import gzip 
import os

paths_to_genomes = "/storage/shared/data_for_master_students/ida_and_ellen/genome_filepaths.tsv"

output_directory = "/storage/koningen"

with open(paths_to_genomes, "r") as file:
    for line in file:
        zipped_file_paths = line.strip()

        if zipped_file_paths.endswith(".gz"):
            file_name = os.path.basename(zipped_file_paths)
            unzipped_file_paths = os.path.join(output_directory, file_name[:-3])

            with gzip.open(zipped_file_paths, "rb") as zipped_file:
                with open(unzipped_file_paths,"wb") as unzipped_file:
                    unzipped_file.write(zipped_file.read())

