
# ---------------------------------------------------
# Create histogram for values in multiple files
# ---------------------------------------------------

library(ggplot2)

count_matrix = c(
  # "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_org_hg.tsv",
  # "/storage/koningen/ranked_counts/individual_counts/highest_individual_counts_org_ww.tsv"
  # "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_org_hg.tsv",
  # "/storage/koningen/ranked_counts/individual_counts/lowest_individual_counts_org_ww.tsv"
  # "/storage/koningen/ranked_counts/average_counts/highest_average_counts_org_hg.tsv",
  # "/storage/koningen/ranked_counts/average_counts/highest_average_counts_org_ww.tsv"
  # "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_org_hg.tsv",
  # "/storage/koningen/ranked_counts/average_counts/lowest_average_counts_org_ww.tsv"
  # "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_org_hg.tsv",
  # "/storage/koningen/ranked_counts/sum_counts/highest_sum_counts_org_ww.tsv"
  # "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_hg.tsv",
  # "/storage/koningen/ranked_counts/sum_counts/lowest_sum_counts_org_ww.tsv"
  "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv",
  "/storage/bergid/taxonomy_rewrites/taxonomy_all_ww_organisms.tsv"
)

all_values <- c()
for (i in count_matrix) {
  data <- read.table(i, sep = "\t", header=TRUE, stringsAsFactors = FALSE)
  values <- as.numeric(unlist(data[, -1])) # Remove the first column with sample names and convert the rest to numeric
  all_values <- c(all_values,values)
}

## Transformation
# values <- log(all_values+1) 
values <- sqrt(all_values)

# change binwidth depending on highest count. 1000 for 44 000 000. 1 for 1000(?)
df <- data.frame(values = values)
  
ggplot(df, aes(x = values)) +
geom_histogram(binwidth = 10, fill = "blue", color = "black", boundary = 0.5) +
labs(title = "SquareRoot-transformed histogram of all organisms", x = "Count Value", y = "Number of counts") +
theme_bw()
#ylim(0, 400)

## not transformed
# ggsave("histograms/bilder/organisms/orgamisms_individual_counts/histogram_org_highest_ind.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/orgamisms_individual_counts/histogram_org_lowest_ind.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_average_counts/histogram_org_highest_mean.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_average_counts/histogram_org_lowest_mean.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_sum_counts/histogram_org_highest_sum.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_sum_counts/histogram_org_lowest_sum.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_all/histogram_org_all.jpg", bg = "white")

## log transformed
# ggsave("histograms/bilder/organisms/orgamisms_individual_counts/histogram_org_highest_ind_log.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/orgamisms_individual_counts/histogram_org_low_ind_log.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_average_counts/histogram_org_highest_mean_log.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_average_counts/histogram_org_lowest_mean_log.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_sum_counts/histogram_org_highest_sum_log.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_sum_counts/histogram_org_lowest_sum_log.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_all/histogram_org_all_log.jpg", bg = "white")


## sqrt transformed
# ggsave("histograms/bilder/organisms/orgamisms_individual_counts/histogram_org_highest_ind_sqrt.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/orgamisms_individual_counts/histogram_org_low_ind_sqrt.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_average_counts/histogram_org_highest_mean_sqrt.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_average_counts/histogram_org_lowest_mean_sqrt.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_sum_counts/histogram_org_highest_sum_sqrt.jpg", bg = "white")
# ggsave("histograms/bilder/organisms/organisms_sum_counts/histogram_org_lowest_sum_sqrt.jpg", bg = "white")
ggsave("histograms/bilder/organisms/organisms_all/histogram_org_all_sqrt.jpg", bg = "white")