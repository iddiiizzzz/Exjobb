
# -------------------------------
# Filter to only species level
# -------------------------------


bacteria = [
    "/storage/koningen/humangut/bacteria_hg.tsv",
    "/storage/koningen/wastewater1/bacteria_ww1.tsv",
    "/storage/koningen/wastewater2/bacteria_ww2.tsv"
    ]

without_sp = [
    "/storage/koningen/humangut/bacteria_species_only_hg.tsv",
    "/storage/koningen/wastewater1/bacteria_species_only_ww1.tsv",
    "/storage/koningen/wastewater2/bacteria_species_only_ww2.tsv"
    ]

for i in range(3):
        
    with open(bacteria[i], "r") as infile, open(without_sp[i], "w") as outfile:
        for line in infile:
            line = line.strip() 
            taxid, name = line.split(maxsplit=1)  # Split taxid and name
            split_name = name.split()
            
            if "sp." not in name and len(split_name) > 1:
                outfile.write(line + "\n")


        