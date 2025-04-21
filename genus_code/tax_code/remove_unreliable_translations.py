
# ----------------------------------------------------------
# Remove unreliable translations
# ----------------------------------------------------------

from collections import defaultdict


infiles = [
    "/storage/koningen/genus/taxonomy_code/bacteria_species_only_hg.tsv",
    "/storage/koningen/genus/taxonomy_code/bacteria_species_only_ww1.tsv",
    "/storage/koningen/genus/taxonomy_code/bacteria_species_only_ww2.tsv"
    ]

outfile = [
    "/storage/koningen/genus/taxonomy_code/bacteria_final_hg.tsv",
    "/storage/koningen/genus/taxonomy_code/bacteria_final_ww1.tsv",
    "/storage/koningen/genus/taxonomy_code/bacteria_final_ww2.tsv"
    ]




for i in range(3):
    duplicate_dict = defaultdict(list)

    # Create dictionary
    with open(infiles[i]) as infile:
        for line in infile:
            line = line.strip()
            columns = line.split("\t") 
            if len(columns) < 2:
                continue  
            taxid = columns[0] 
            duplicate_dict[taxid].append(line)  

    # Find duplicates
    with open(outfile[i], "w") as out:
        for taxid, lines in duplicate_dict.items():
            if len(lines) == 1:  # More than one occurrence
                 out.write(lines[0] + "\n")




