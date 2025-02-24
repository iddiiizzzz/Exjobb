
# --------------------------------------------------
# Correlation of each organism over all samples
# --------------------------------------------------

import numpy as np
from scipy.stats import pearsonr


# count_matrix = "test_files/rewritten_test_kraken1.tsv"
# results = "test_files/results_org_correlation_ww1_test.tsv"

count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv"
results = "/storage/bergid/correlation/results_org_correlation_ww1.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_ww2.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_hg.tsv"
# count_matrix = "/storage/bergid/taxonomy_rewrites/taxonomy_all_organisms.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_all.tsv"



transformed_counts = []
names = []
with open(count_matrix, 'r') as infile:
    next(infile)
    
    for line in infile:
        columns = line.strip().split("\t")
        name = columns[0]
        count_values = np.array(columns[1:], dtype=float)

        if np.mean(count_values) == 0:
            continue


        transformed_counts.append(np.log(count_values + 1))
        names.append(name)

transformed_counts = np.array(transformed_counts)
results_list = []     
print(len(transformed_counts))

for i in range(len(transformed_counts)):
    print(i)
    for j in range(i, len(transformed_counts)):
        if i==j:
            corr_coefficient, p_value = 1.0, 0.0
        else:
            corr_coefficient, p_value = pearsonr(transformed_counts[i], transformed_counts[j])
        
        org1, org2 = names[i], names[j]
        results_list.append(f"{org1}\t{org2}\t{corr_coefficient:.6f}\t{p_value:.6f}\n")


with open(results, 'w') as outfile:
    outfile.write("Organism1\tOrganism2\tCorrelationCoefficient\tpValue\n")
    outfile.writelines(results_list)