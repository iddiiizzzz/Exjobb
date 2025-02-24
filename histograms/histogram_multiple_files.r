
# ---------------------------------------------------
# Create histogram for values in multiple files
# ---------------------------------------------------

library(ggplot2)

# count_matrix = c(
#     "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv",
#     "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv", 
#     "/storage/bergid/taxonomy_rewrites/taxonomy_hg.tsv"
# )

count_matrix = c(
    "/storage/bergid/taxonomy_rewrites/taxonomy_ww1.tsv",
    "/storage/bergid/taxonomy_rewrites/taxonomy_ww2.tsv"
)


all_values <- c()
for (i in count_matrix) {
  data <- read.table(i, sep = "\t", header=TRUE, stringsAsFactors = FALSE)
  values <- as.numeric(unlist(data[, -1])) # Remove the first column with sample names and convert the rest to numeric
  all_values <- c(all_values,values)
}


# change binwidth depending on highest count. 1000 for 44 000 000. 1 for 1000(?)
df <- data.frame(values = values)
ggplot(df, aes(x = values)) +
  geom_histogram(binwidth = 1000, fill = "blue", color = "black", boundary = 0.5) +
  labs(title = "Histogram of Count Values", x = "Count Value", y = "Number of counts") +
  theme_bw() +
  ylim(0, 400)

ggsave("histograms/bilder/organisms_all/histogram_org_ww.jpg", bg = "white")

# Rscript histograms/histogram_multiple_files.r

