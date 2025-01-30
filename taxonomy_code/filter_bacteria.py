relevant_names = "taxonomy_code/taxonomy_outputs/bacteria.tsv"
without_sp = "taxonomy_code/taxonomy_outputs/filtered_bacteria.tsv"

with open(relevant_names, "r") as infile, open(without_sp, "w") as outfile:
    for line in infile:
        line = line.strip()  # Remove leading/trailing whitespace
        taxid, name = line.split(",")  # Split taxid and name
        split_name = name.split()
        
        if "sp." not in name and len(split_name) > 1:
            outfile.write(line + "\n")


        