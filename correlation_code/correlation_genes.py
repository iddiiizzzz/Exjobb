
# --------------------------------------------------
# Correlation of each gene over all samples
# --------------------------------------------------

import numpy as np
from scipy.stats import pearsonr

gene_counts = "/storage/koningen/count_matrix.tsv"
results = "/storage/bergid/correlation/results_gene_correlation.tsv"
#highest_raw_counts = "/storage/koningen/ranked_counts/highest_average_counts.tsv"


transformed_counts = []
gene_names = []
with open(gene_counts, 'r') as infile:
    next(infile)
    
    for line in infile:
        columns = line.strip().split("\t")
        gene_name = columns[0]
        gene_values = np.array(columns[1:], dtype=float)

        if np.mean(gene_values) == 0:
            continue


        transformed_counts.append(np.log(gene_values + 1))
        gene_names.append(gene_name)

transformed_counts = np.array(transformed_counts)
results_list = []     

for i in range(len(transformed_counts)):
    print(i)
    for j in range(i, len(transformed_counts)):
        if i==j:
            corr_coefficient, p_value = 1.0, 0.0
        else:
            corr_coefficient, p_value = pearsonr(transformed_counts[i], transformed_counts[j])
        
        gene1, gene2 = gene_names[i], gene_names[j]
        results_list.append(f"{gene1}\t{gene2}\t{corr_coefficient:.6f}\t{p_value:.6f}\n")


with open(results, 'w') as outfile:
    outfile.write("Gene1\tGene2\tCorrelationCoefficient\tpValue\n")
    outfile.writelines(results_list)