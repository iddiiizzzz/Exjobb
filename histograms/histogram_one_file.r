
# ------------------------------------------------------------------------------------------------------------

# Create histogram for count values.

# Input:
#     - infile: Path to the count matrix of the genes or organisms with the highest or lowest counts.

# Output:
#     - outfile: Path to the created image in png format.

# Notes:
#     - Add the line for limit the y-axis if it get too high to see the rest of the data.
#     - Change the out commented input files and ggsave lines depending on which data to use.
#     - Change transformation depending on which one you want to use.
#     - Change the title depending on the data.

# ------------------------------------------------------------------------------------------------------------


library(ggplot2)
library(showtext)

# Latex font
font_add(family = "LM Roman", regular = "/storage/koningen/latex-font/lmroman10-regular.otf")
showtext_auto()

##all genes + gene highest mean

# Gene counts
# infile = "/storage/koningen/count_matrix.tsv"

# infile = "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_gene.tsv"
# infile = "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_gene.tsv"
# 
# infile = "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_gene.tsv"
# infile = "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_gene.tsv"

infile = "/storage/koningen/ranked_counts/average_counts/highest_average_counts_gene.tsv"
# infile = "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_gene.tsv"



# outfile = "histograms/bilder/genes/genes_all/histogram_genes.eps"

# outfile = "histograms/bilder/genes/one_gene_histograms/highest_individual_count_gene_log.eps"
# outfile = "histograms/bilder/genes/one_gene_histograms/lowest_individual_count_gene_sqrt.eps"

# outfile = "histograms/bilder/genes/one_gene_histograms/highest_sum_count_gene_sqrt.eps"
# outfile = "histograms/bilder/genes/one_gene_histograms/lowest_sum_count_gene_sqrt.eps"

outfile = "histograms/bilder/genes/one_gene_histograms/highest_mean_count_gene_sqrt.eps"
# outfile = "histograms/bilder/genes/one_gene_histograms/lowest_mean_count_gene_sqrt.eps"


# # Organism counts
# data <- read.table("/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_hg.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)



data <- read.table(infile, sep = "\t", header = TRUE, stringsAsFactors = FALSE)

values <- as.numeric(unlist(data[, -1]))  


values <- log(values+1) 
# values <- sqrt(values)
df <- data.frame(values = values)


# change binwidth depending on highest count. 1000 for 44 000 000. 1 for 1000
ggplot(df, aes(x = values)) +
  geom_histogram(binwidth = 1, fill = "#00cfba", boundary = 0.5) +
  labs(title = "Log-transformed histogram of gene with highest individual count", 
       x = "Count Value", 
       y = "Number of counts") +
  theme_bw() +
  theme(
    text = element_text(family = "LM Roman"),         # Set global font
    plot.title = element_text(size = 40),         # Title font size
    axis.title.x = element_text(size = 40),       # X-axis title font size
    axis.title.y = element_text(size = 40),       # Y-axis title font size
    axis.text.x = element_text(size = 40),        # X-axis tick label size
    axis.text.y = element_text(size = 40)         # Y-axis tick label size
  )
 # ylim(0, 200000)

ggsave(outfile, bg = "white", device = "eps")
 




