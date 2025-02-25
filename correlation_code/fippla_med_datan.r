



# results <- "test_files/results_org_correlation_ww1_test.tsv"

# correlation = "/storage/bergid/correlation/results_org_correlation_ww1_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_ww2_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_hg_log.tsv"
# results = "/storage/bergid/correlation/results_org_correlation_all_log.tsv"


# Läs in filen med tab-avgränsade värden (se till att filen har en header)
df <- read.table("/storage/bergid/correlation/results_org_correlation_ww1_log.tsv", 
                 sep = "\t", header = TRUE, stringsAsFactors = FALSE)

# Kontrollera att kolumnen heter "CorrelationCoefficient" - om inte, anpassa namnet nedan.
# Vi sorterar i fallande ordning (högsta värden först)
df_ordered <- df[order(-df$CorrelationCoefficient), ]

# Skriv ut den sorterade datan till en ny fil
write.table(df_ordered, file = "/storage/bergid/correlation/results_org_correlation_ww1_log_ordered.tsv", 
            sep = "\t", quote = FALSE, row.names = FALSE)
#/storage/bergid/correlation/results_org_correlation_ww1_log_ordered.tsv