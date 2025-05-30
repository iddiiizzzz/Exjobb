
# -------------------------------------------------------------------------------
# Filter bacteria viruses and other things that are not in the relevant set of genomes
# -------------------------------------------------------------------------------

full_taxonomy = "/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv"
taxids_with_names = [
    "/storage/koningen/species/taxonomy_code/humangut_taxid_to_names_without_duplicates.tsv",
    "/storage/koningen/species/taxonomy_code/wastewater1_taxid_to_names_without_duplicates.tsv",
    "/storage/koningen/species/taxonomy_code/wastewater2_taxid_to_names_without_duplicates.tsv"
]
bacteria = [
    "/storage/koningen/species/taxonomy_code/bacteria_hg.tsv",
    "/storage/koningen/species/taxonomy_code/bacteria_ww1.tsv",
    "/storage/koningen/species/taxonomy_code/bacteria_ww2.tsv"
    ]




for i in range(3):
        
    # Load all lines of full_taxonomy for searching
    with open(full_taxonomy, "r") as tax_file:
        taxonomy_lines = tax_file.readlines()  # Read all lines into a list

    with open(taxids_with_names[i], "r") as infile, open(bacteria[i], "w") as outfile:
        for line in infile:
            print(line)
            line = line.strip() 
            taxid, name = line.split(maxsplit=1)  # Split taxid and name
            
            # Check if the name appears in any line of the taxonomy file and write it to the oufile
            if any(name in taxonomy_line for taxonomy_line in taxonomy_lines):
                outfile.write(line + "\n")


