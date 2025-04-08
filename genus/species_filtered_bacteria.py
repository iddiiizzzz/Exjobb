
# -------------------------------
# Filter to only species level
# -------------------------------


bacteria =  [
    "/storage/koningen/genus/bacteria_hg.tsv",
    "/storage/koningen/genus/bacteria_ww1.tsv",
    "/storage/koningen/genus/bacteria_ww2.tsv"
    ]

without_sp = [
    "/storage/koningen/genus/bacteria_species_only_hg.tsv",
    "/storage/koningen/genus/bacteria_species_only_ww1.tsv",
    "/storage/koningen/genus/bacteria_species_only_ww2.tsv"
    ]


for i in range(3):
        
    with open(bacteria[i], "r") as infile, open(without_sp[i], "w") as outfile:
        outfile.write("TaxID\tOrgNames\n")
        for line in infile:
            line = line.strip() 
            taxid, name = line.split(maxsplit=1)  # Split taxid and name
            split_name = name.split()
            
            if "sp." not in name:
                outfile.write(line + "\n")


        