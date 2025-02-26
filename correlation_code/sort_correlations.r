
# ------------------------------------------------------------------
# Order the rows in correlation results after coefficient value
# ------------------------------------------------------------------


# results <- "test_files/results_org_correlation_ww1_test.tsv"

# correlation = "/storage/bergid/correlation/results_org_correlation_ww1_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_ww2_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_hg_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_all_log.tsv"
# /storage/bergid/correlation/results_org_correlation_all_log_switchLogSum.tsv


df <- read.table("/storage/bergid/correlation/results_org_correlation_all_log_switchLogSum.tsv", 
                 sep = "\t", header = TRUE, stringsAsFactors = FALSE)

df_filtered <- subset(df, CorrelationCoefficient != 1 & !is.na(pValue) & pValue != 0)


df_ordered <- df_filtered[order(-df_filtered$CorrelationCoefficient), ]  


write.table(df_ordered, file = "/storage/bergid/correlation/results_org_correlation_all_log_ordered_switched.tsv", 
            sep = "\t", quote = FALSE, row.names = FALSE)

#/storage/bergid/correlation/results_org_correlation_ww1_log_ordered.tsv