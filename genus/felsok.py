

# outfile = "/storage/bergid/filtered_taxids_felsok.tsv" # har header
# outfile2 = "/storage/bergid/columns_to_keep_felsok.tsv"

# outfile = "/storage/koningen/genus/bacteria_species_only_hg.tsv"
# with open(outfile) as f1, open(outfile2) as f2:
#     set1 = set(line.strip() for line in f1)
#     set2 = set(line.strip() for line in f2)

# only_in_file1 = set1 - set2
# only_in_file2 = set2 - set1

# print("Only in file1:")
# print("\n".join(sorted(only_in_file1)))

# print("\nOnly in file2:")
# print("\n".join(sorted(only_in_file2)))

# -----------------------------------------------------------------------------

# from collections import Counter

# with open(outfile) as f:
#     lines = [line.strip() for line in f]

# counts = Counter(lines)

# duplicates = {line: count for line, count in counts.items() if count > 1}

# if duplicates:
#     print("Found duplicates:")
#     for line, count in duplicates.items():
#         print(f"{line}: {count} times")
# else:
#     print("No duplicates found.")



from collections import defaultdict

outfile = "/storage/koningen/genus/bacteria_species_only_hg.tsv"

# Dictionary to store duplicate entries (key: first column, value: list of lines)
duplicate_dict = defaultdict(list)

# Read the file and track occurrences of the first column
with open(outfile) as f:
    for line in f:
        line = line.strip()
        columns = line.split("\t")  # Assuming tab-separated values
        if len(columns) < 2:
            continue  # Skip malformed lines
        taxid = columns[0]  # First column value
        duplicate_dict[taxid].append(line)  # Store full line for review

# Print duplicates
found_duplicates = False
for taxid, lines in duplicate_dict.items():
    if len(lines) > 1:  # More than one occurrence
        found_duplicates = True
        print(f"Duplicates for taxid {taxid}:")
        for duplicate_line in lines:
            print(duplicate_line)

if not found_duplicates:
    print("No duplicates found.")



# /storage/bergid/dictionaries/assembly_accession_to_org_names.tsv  
# /storage/bergid/dictionaries/taxid_to_assembly_accession.tsv