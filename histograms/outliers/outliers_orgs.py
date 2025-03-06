
## Organisms
count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
#count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
#count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"

outliers = "/storage/bergid/outliers/orgs_with_outliers_hg.tsv"
#outliers = "/storage/bergid/outliers/orgs_with_outliers_ww1.tsv"
#outliers = "/storage/bergid/outliers/orgs_with_outliers_ww2.tsv"


# Set to track organisms that exceed the threshold
outlier_organisms = set()

# Read the file and process each row
with open(count_matrix, "r") as infile:
    next(infile)  # Skip header
    
    for index, line in enumerate(infile):
        print(f"Processing organism {index}")

        columns = line.strip().split("\t") 
        identifier = columns[0]  # First column (organism ID)
        numeric_values = list(map(int, columns[1:]))  # Convert counts to integers
        
        row_sum = sum(numeric_values)

        # Check if any value exceeds 10% of row sum
        if row_sum > 0:
            for column in numeric_values:
                count_proportion = column / row_sum
                if count_proportion > 0.1:
                    outlier_organisms.add(identifier)  # Add to set (avoids duplicates)
                    break  # No need to check more values for this organism

# Write unique outlier organism names to a file
with open(outliers, "w") as outfile:
    for organism in outlier_organisms:
        outfile.write(f"{organism}\n")

print(f"Saved {len(outlier_organisms)} unique outliers to {outliers}")
