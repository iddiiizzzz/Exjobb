
# ------------------------------------------------------------------
# Order the rows in correlation results after coefficient value
# ------------------------------------------------------------------

# file_path <- "/storage/bergid/correlation/both/final_correlation_weighted_ww.tsv"
# outfile <- "/storage/bergid/correlation/both/final_correlation_weighted_ww_sorted.tsv"
file_path <- "/storage/bergid/correlation/both/final_correlation_weighted_hg.tsv"
outfile <- "/storage/bergid/correlation/both/final_correlation_weighted_hg_sorted.tsv"

# file_path <- "/storage/bergid/correlation/both/final_correlation_filtered_hg.tsv"
# outfile <- "/storage/bergid/correlation/both/final_correlation_filtered_hg_sorted.tsv"
# file_path <- "/storage/bergid/correlation/both/final_correlation_filtered_ww.tsv"
# outfile <- "/storage/bergid/correlation/both/final_correlation_filtered_ww_sorted.tsv"

df <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE)

df_filtered <- subset(df, CorrelationCoefficient != 1)
df_ordered <- df_filtered[order(-df_filtered$CorrelationCoefficient), ]  

write.table(df_ordered, outfile, sep = "\t", row.names = FALSE, quote = FALSE)

