
# -------------------------------------------------
# Create histogram for values in one  file
# -------------------------------------------------


library(ggplot2)

# Full data counts
# data <- read.table("/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/count_matrix.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)


# # Gene counts
infile = "/storage/koningen/count_matrix.tsv"

# infile = "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_gene.tsv"
# infile = "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_gene.tsv"
# 
# infile = "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_gene.tsv"
# infile = "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_gene.tsv"

# infile = "/storage/koningen/ranked_counts/average_counts/highest_average_counts_gene.tsv"
# infile = "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_gene.tsv"



outfile = "histograms/bilder/genes/genes_all/log_transformed_histogram_genes.jpg"

# outfile = "histograms/bilder/genes/one_gene_histograms/highest_individual_count_gene_sqrt.jpg"
# outfile = "histograms/bilder/genes/one_gene_histograms/lowest_individual_count_gene_sqrt.jpg"

# outfile = "histograms/bilder/genes/one_gene_histograms/highest_sum_count_gene_sqrt.jpg"
# outfile = "histograms/bilder/genes/one_gene_histograms/lowest_sum_count_gene_sqrt.jpg"

# outfile = "histograms/bilder/genes/one_gene_histograms/highest_mean_count_gene_sqrt.jpg"
# outfile = "histograms/bilder/genes/one_gene_histograms/lowest_mean_count_gene_sqrt.jpg"



# # Organism counts
# data <- read.table("/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_hg.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)


data <- read.table(infile, sep = "\t", header = TRUE, stringsAsFactors = FALSE)

values <- as.numeric(unlist(data[, -1]))  


values <- log(values+1) 
# values <- sqrt(values)
df <- data.frame(values = values)


# change binwidth depending on highest count. 1000 for 44 000 000. 1 for 1000(?)
ggplot(df, aes(x = values)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black", boundary = 0.5) +
  labs(title = "Log-transformed histogram of all gene counts", x = "Count Value", y = "Number of counts") +
  theme_bw() +
  ylim(0, 500)


ggsave(outfile, bg = "white")


# Rscript histograms/histogram_one_file.r

