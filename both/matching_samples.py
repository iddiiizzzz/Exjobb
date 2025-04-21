

"""
    Filters the count matrices for genes and organisms to only keep the samples that exists in both files.

    Input:
        - genes_infile: Path to the file with the count matrix for the genes.
        - orgs_outfile: Path to the file with the counts matrix for the organisms.

    Output:
        - genes_outfile: Path to the output file stores the sample filtered count matrix for the genes.
        - orgs_outfile: Path to the output file stores the sample filtered count matrix for the organisms.

"""

import pandas as pd

genes_infile = "/storage/koningen/count_matrix_filtered.tsv"



# Species separated
# orgs_infile = "/storage/koningen/species/taxonomy_code/taxonomy_ww1.tsv"
# genes_outfile = "/storage/koningen/species/matching_samples/matching_count_matrix_genes_ww1.tsv"
# orgs_outfile = "/storage/koningen/species/matching_samples/matching_count_matrix_orgs_ww1.tsv"

# orgs_infile = "/storage/koningen/species/taxonomy_code/taxonomy_ww2.tsv"
# genes_outfile = "/storage/koningen/species/matching_samples/matching_count_matrix_genes_ww2.tsv"
# orgs_outfile = "/storage/koningen/species/matching_samples/matching_count_matrix_orgs_ww2.tsv"

# orgs_infile = "/storage/koningen/species/taxonomy_code/taxonomy_hg.tsv"
# genes_outfile = "/storage/koningen/species/matching_samples/matching_count_matrix_genes_hg.tsv"
# orgs_outfile = "/storage/koningen/species/matching_samples/matching_count_matrix_orgs_hg.tsv"



# Genus separated
# orgs_infile = "/storage/koningen/genus/taxonomy_code/taxonomy_ww1.tsv"
# genes_outfile = "/storage/koningen/genus/matching_samples/matching_count_matrix_genes_ww1.tsv"
# orgs_outfile = "/storage/koningen/genus/matching_samples/matching_count_matrix_orgs_ww1.tsv"

# orgs_infile = "/storage/koningen/genus/taxonomy_code/taxonomy_ww2.tsv"
# genes_outfile = "/storage/koningen/genus/matching_samples/matching_count_matrix_genes_ww2.tsv"
# orgs_outfile = "/storage/koningen/genus/matching_samples/matching_count_matrix_orgs_ww2.tsv"

orgs_infile =  "/storage/koningen/genus/taxonomy_code/taxonomy_hg.tsv"
genes_outfile = "/storage/koningen/genus/matching_samples/matching_count_matrix_genes_hg.tsv"
orgs_outfile = "/storage/koningen/genus/matching_samples/matching_count_matrix_orgs_hg.tsv"


# Test
# genes_infile = "test_files/count_matrix_genes_test_blast.tsv"
# orgs_infile = "test_files/test_org_count_matrix_blast.tsv"
# genes_outfile = "test_files/matching_samples_genes.tsv"
# orgs_outfile = "test_files/matching_samples_orgs.tsv"


genes = pd.read_csv(genes_infile, sep="\t")
orgs = pd.read_csv(orgs_infile, sep="\t")

columns_to_keep_gene = ["GeneNames"]
for gene_sample in genes.columns:
    print(f"Gene sample: {gene_sample}")
    for org_sample in orgs.columns:
        if org_sample == gene_sample:
            columns_to_keep_gene.append(gene_sample)
            break
gene_result = genes[columns_to_keep_gene]

columns_to_keep_org = ["OrgNames"]
for org_sample in orgs.columns:
    print(f"Organism sample: {org_sample}")
    for gene_sample in genes.columns:
        if org_sample == gene_sample:
            columns_to_keep_org.append(org_sample)
            break
org_result = orgs[columns_to_keep_org]

gene_result.to_csv(genes_outfile, sep="\t", index = False)
org_result.to_csv(orgs_outfile, sep="\t", index = False)
