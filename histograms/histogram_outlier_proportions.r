
library(ggplot2)

#infile <- "/storage/bergid/outliers/outliers_in_orgs_hg.tsv"
#infile <- "/storage/bergid/outliers/outliers_in_orgs_ww1.tsv"
#infile <- "/storage/bergid/outliers/outliers_in_orgs_ww2.tsv"

#infile <- "/storage/bergid/outliers/outliers_in_samples_hg.tsv"
#infile <- "/storage/bergid/outliers/outliers_in_samples_ww1.tsv"
#infile <- "/storage/bergid/outliers/outliers_in_samples_ww2.tsv"

infile <- "/storage/bergid/outliers/unfiltered_outliers_in_orgs_hg.tsv"

data <- read.table(infile, header=FALSE) 

# Create histogram for proportions
ggplot(data, aes(x = V3)) +  # V3 = third column
  geom_histogram(bins = 1000, fill="blue", color="black") + 
  labs(title="Histogram of Probabilities", x="Probability", y="Frequency")

ggsave("histograms/bilder/outlier_proportions/unfiltered_outliers_in_orgs_hg.jpg", bg = "white")

