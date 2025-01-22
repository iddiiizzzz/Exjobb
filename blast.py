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

/storage/shared/data_for_master_students/ida_and_ellen

----------------------------------------------------------------------------------------------

to work in conda: conda activate exjobb_env

skriva om id: seq1, seq2, seq3 etc

makeblastdb -in shorter_id.fna -dbtype nucl -out /storage/koningen/antibiotic_resistance_db -title "Antibiotic Resistance Genes DB" -parse_seqids

blastn -query /storage/koningen/GCA_001141985.1_6259_7_14_genomic.fna -db /storage/koningen/antibiotic_resistance_db -out blast_results_example.txt

example query: 
       /storage/shared/ncbi_bacteria_assembly/GCA/001/141/985/GCA_001141985.1_6259_7_14/GCA_001141985.1_6259_7_14_genomic.fna.gz

------------------------------------------------------------------------------
gunzip file.fna.gz --> file.fna

'''