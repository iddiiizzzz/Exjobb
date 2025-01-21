'''
Commands:
- blastn
- makeblastdb

Files:
- antibiotic_resistance_genes.fna - FASTA-fil med alla resistensgener, detta är vår input fil
- genome_filepaths.tsv - Paths till alla relevanta bakteriegenom på servern

(Andra filer):
- count_matrix.tsv - Abundans av resistensgener i metagenom
- genome_full_lineage.tsv - Komplett taxonomi för alla bakteriegenomen
- taxonomy_metagenomes.csv - Taxonomi i de metagenomiska proverna genererade med Kraken2

makeblastdb -in /storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna -parse_seqids -blastdb_version 5 -taxid_map /storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv -title "BLAST_db" -dbtype nucl
/storage/shared/data_for_master_students/ida_and_ellen/antibiotic_resistance_genes.fna
/storage/shared/data_for_master_students/ida_and_ellen/genome_full_lineage.tsv
'''