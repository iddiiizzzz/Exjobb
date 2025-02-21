
# -------------------------------------------------
# Create histogram for values in one  file
# -------------------------------------------------


library(ggplot2)

# Full data counts
data <- read.table("/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/count_matrix.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)

# # Gene counts
# data <- read.table("/storage/koningen/ranked_counts/highest_raw_counts_gene.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/lowest_raw_counts_gene.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/highest_average_counts_gene.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/lowest_average_counts_gene.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/highest_sum_counts_gene.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/lowest_sum_counts_gene.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)

# # Organism counts
# data <- read.table("/storage/koningen/ranked_counts/highest_raw_counts_org.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/lowest_raw_counts_org.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/highest_average_counts_org.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/lowest_average_counts_org.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/highest_sum_counts_org.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# data <- read.table("/storage/koningen/ranked_counts/lowest_sum_counts_org.tsv", sep = "\t", header = TRUE, stringsAsFactors = FALSE)




values <- as.numeric(unlist(data[, -1]))  # Remove the first column with sample names and convert the rest to numeric
df <- data.frame(values = values)


# change binwidth depending on highest count. 1000 for 44 000 000. 1 for 1000(?)
df <- data.frame(values = values)
ggplot(df, aes(x = values)) +
  geom_histogram(binwidth = 1000, fill = "blue", color = "black", boundary = 0.5) +
  labs(title = "Histogram of Count Values", x = "Count Value", y = "Number of counts") +
  theme_minimal() +
  ylim(0, 400)

ggsave("histograms/bilder/organisms_all/histogram_org_hg.jpg")


# Rscript histograms/histogram_one_file.r

