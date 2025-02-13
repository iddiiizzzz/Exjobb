
# -------------------------------
# Filter to only species level
# -------------------------------


bacteria = "/storage/koningen/bacteria.tsv"
without_sp = "taxonomy_code/taxonomy_outputs/bacteria_species_only.tsv"


with open(bacteria, "r") as infile, open(without_sp, "w") as outfile:
    for line in infile:
        line = line.strip() 
        taxid, name = line.split(maxsplit=1)  # Split taxid and name
        split_name = name.split()
        
        if "sp." not in name and len(split_name) > 1:
            outfile.write(line + "\n")


        