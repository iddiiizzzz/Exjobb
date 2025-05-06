
"""
    Finds the unique organisms that have outliers.

    Input:
        - count_matrix: Path to the count matrix of interest.

    Output:
        - outliers: Path to the outputfile that stores the taxids that have outlier counts.

    Notes:
        - Change the out commented files depending on which data set to examine.

"""


count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
#count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
#count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"

outliers = "/storage/bergid/outliers/orgs_with_outliers_hg.tsv"
#outliers = "/storage/bergid/outliers/orgs_with_outliers_ww1.tsv"
#outliers = "/storage/bergid/outliers/orgs_with_outliers_ww2.tsv"



outlier_organisms = set()

with open(count_matrix, "r") as infile:
    next(infile) 
    
    for index, line in enumerate(infile):
        print(f"Processing organism {index}")

        columns = line.strip().split("\t") 
        identifier = columns[0] 
        numeric_values = list(map(int, columns[1:]))  
        
        row_sum = sum(numeric_values)

        # Check if any value exceeds 10% of row sum
        if row_sum > 0:
            for column in numeric_values:
                count_proportion = column / row_sum
                if count_proportion > 0.1:
                    outlier_organisms.add(identifier)  # Avoids duplicates
                    break  

# Write unique outlier organism names to a file
with open(outliers, "w") as outfile:
    for organism in outlier_organisms:
        outfile.write(f"{organism}\n")

print(f"Saved {len(outlier_organisms)} unique outliers to {outliers}")
