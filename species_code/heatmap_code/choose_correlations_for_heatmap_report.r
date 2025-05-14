
# ------------------------------------------------------------------------------------------------------------

# Saves only some matches for a smaller heatmap that fits in the report

# ------------------------------------------------------------------------------------------------------------



full_correlation <- "/storage/bergid/correlation/species/both/normalized_correlation_zinb_weighted_all_status.tsv"
chosen_correlations <- "/storage/bergid/correlation/species/both/chosen_correlations_for_report_heatmap_new.tsv"



correlations <- read.table(full_correlation, sep = "\t", header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)



row1 <- correlations[correlations$Gene == "GCA_001670625.2_ASM167062v2_CP121209.1_seq1...class_A", ]
row2 <- correlations[correlations$Gene == "tet.37.", ]
row3 <- correlations[correlations$Gene == "GCA_000302535.1_ASM30253v1_CP003872.1_seq1…class_A", ]
row4 <- correlations[correlations$Gene == "GCA_000020605.1_ASM2060v1_CP001107.1_seq1...aac6p_class2", ]
row5 <- correlations[correlations$Gene == "GCA_000473955.1__oprFasNSB1_KI440787.1_seq1...class_A", ]
row6 <- correlations[correlations$Gene == "GCA_000949455.1_ASM94945v1_JXXK01000004.1_seq1...aac6p_class2", ]
row7 <- correlations[correlations$Gene == "GCA_024460255.1_ASM2446025v1_JANFYA010000023.1_seq1...erm_typeF", ]
row8 <- correlations[correlations$Gene == "GCA_000203195.1_ASM20319v1_FR824044.1_seq1...tet_rpg", ]
row9 <- correlations[correlations$Gene == "GCA_002874775.1_ASM287477v1_CP020991.1_seq1...tet_rpg", ]
row10 <- correlations[correlations$Gene == "GCA_021467745.1_PDT001222373.1_DAFLVH010000092.1_seq1...aph3p", ]

excluded_orgs <- c("Acidaminococcus intestini", "Blautia argi", "Anaerotruncus colihominis", "Faecalibacillus intestinalis", "Salmonella enterica", "Treponema denticola", "Streptococcus intermedius", "Enterocloster closttridioformis", "Streptococcus anginosus", "Enterococcus suis", "Bacteroides caccae", "Parabacteroides distasonis", "Paraprevotella clara", "Ruthenibacterium lactatiformans", "Sellimonas intestinalis", "Hungatella hathewayi", "Clostridium] symbiosum", "Ruminococcus] torques", "Haemophilus] ducreyi", "Agathobacter rectalis", "Bacteroides johnsonii", "Enterococcus faecium", "Bacteroides uniformis", "Parabacteroides merdae", "Alistipes shahii", "Bacteroides stercoris", "Blautia massiliensis ex Durand et al. 2017", "Clostridioides diffcile", "Clostridium] scindens", "Thomasclavaelia ramosa", "Bacteroides xylanisolyens", "Phocaeicola dorei", "Blautia obeum", "Dorea formicigenerans", "Megamonas funiformis", "intestimonas butyriciproducens", "Lachnospira eligens", "Blautia wexlerae", "Solobacterium moorei", "Streptococcus suis", "Mediterraneibacter gnavus", "Bacteroides ovatus", "Enterocloster clostridioformis", "Parabacteroides johnsonii")



saved_rows <- unique(rbind(row1, row2, row3, row4, row5, row6, row7, row8, row9, row10))

saved_rows <- saved_rows[!saved_rows$Organism %in% excluded_orgs, ]


write.table(saved_rows, file = chosen_correlations, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
