
# ------------------------------------------------------------------
# Order the rows in correlation results after coefficient value
# ------------------------------------------------------------------

### Correlation weighted
## Normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_sorted.tsv"

# ww
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_ww_sorted.tsv"

# hg
# file_path <-  "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_without_duplicates.tsv"
# outfile <-  "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_hg_sorted.tsv"


## Non-normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_all_sorted.tsv"

# ww
# file_path <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_ww_sorted.tsv"

#hg
# file_path <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/correlation_zinb_weighted_hg_sorted.tsv"



### Correlation filtered
## Normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_all_sorted.tsv"

# ww
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_ww_sorted.tsv"

# hg
# file_path <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/normalized_correlation_filtered_hg_sorted.tsv"


## Non-normalized
# all 
# file_path <- "/storage/bergid/correlation/species/both/correlation_filtered_all_without_duplicates.tsv" 
# outfile <- "/storage/bergid/correlation/species/both/correlation_filtered_all_sorted.tsv"

# ww
# file_path <- "/storage/bergid/correlation/species/both/correlation_filtered_ww_without_duplicates.tsv"
# outfile <- "/storage/bergid/correlation/species/both/correlation_filtered_ww_sorted.tsv"

#hg
file_path <- "/storage/bergid/correlation/species/both/correlation_filtered_hg_without_duplicates.tsv"
outfile <- "/storage/bergid/correlation/species/both/correlation_filtered_hg_sorted.tsv"



df <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE)

df_filtered <- subset(df, CorrelationCoefficient != 1)
df_ordered <- df_filtered[order(-df_filtered$CorrelationCoefficient), ]  

write.table(df_ordered, outfile, sep = "\t", row.names = FALSE, quote = FALSE)

