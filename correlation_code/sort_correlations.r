
# ------------------------------------------------------------------
# Order the rows in correlation results after coefficient value
# ------------------------------------------------------------------

# # file_path <- "test_files/results_org_correlation_ww1_test.tsv"

file_path <- "/storage/bergid/correlation/results_org_correlation_all_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_hg_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww2_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_hg_log.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww2_log.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_all_log.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww1_log75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_all_log_sep75.tsv"
#file_path <- "/storage/bergid/correlation/results_org_correlation_ww1_log.tsv"


### results  
outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_all_log_ordered_75.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_hg_log_ordered_75.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_ww2_log_ordered_75.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_hg_log_ordered.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_ww2_log_ordered.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_all_log_ordered.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_ww1_log_ordered_75.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_all_log_separate_ordered_75.tsv"
#outfile <- "/storage/bergid/correlation/ordered_correlations/results_org_correlation_ww1_log_ordered.tsv"

df <- read.table(file_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE)

df_filtered <- subset(df, CorrelationCoefficient != 1)
df_ordered <- df_filtered[order(-df_filtered$CorrelationCoefficient), ]  

write.csv(df_ordered, outfile, row.names = FALSE)

#excel funkar inte med så många rader