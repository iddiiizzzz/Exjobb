
# ------------------------------------------------------------------
# Order the rows in correlation results after coefficient value
# ------------------------------------------------------------------


# results <- "test_files/results_org_correlation_ww1_test.tsv"

# correlation = "/storage/bergid/correlation/results_org_correlation_ww1_log.tsv" 
# results = "/storage/bergid/correlation/results_org_correlation_ww2_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_hg_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_all_log.tsv"

# results = "/storage/bergid/correlation/results_org_correlation_ww1_log75.tsv" #correlation (ida)
# results = "/storage/bergid/correlation/results_org_correlation_ww2_log75.tsv" #correlation_2 (ida)
# results = "/storage/bergid/correlation/results_org_correlation_hg_log75.tsv" #correlation_3 (ida)
# results = "/storage/bergid/correlation/results_org_correlation_all_log75.tsv" #correlation (ellen)
# results <- "/storage/bergid/correlation/results_org_correlation_all_log_sep75.tsv" #correlation2 (ellen)


df <- read.table("/storage/bergid/correlation/results_org_correlation_all_log_sep75.tsv", 
                 sep = "\t", header = TRUE, stringsAsFactors = FALSE)

df_filtered <- subset(df, CorrelationCoefficient != 1 & !is.na(pValue) & pValue != 0)


df_ordered <- df_filtered[order(-df_filtered$CorrelationCoefficient), ]  


write.table(df_ordered, file = "/storage/bergid/correlation/results_org_correlation_all_log_separate_ordered_75.tsv", 
            sep = "\t", quote = FALSE, row.names = FALSE)

#/storage/bergid/correlation/results_org_correlation_ww1_log_ordered.tsv