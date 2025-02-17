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
       - taxonomy_wastewater_1.tsv
       - taxonomy_wastewater_2.tsv
       - taxonomy_human_gut.tsv

/storage/shared/data_for_master_students/ida_and_ellen

----------------------------------------------------------------------------------------------

to work in conda: conda activate exjobb_env

skriva om id: seq1, seq2, seq3 etc

makeblastdb -in /storage/bergid/shorter_id.fna -dbtype nucl -out /storage/bergid/antibiotic_resistance_db -title "Antibiotic Resistance Genes DB" -parse_seqids

blastn -query /storage/bergid/GCA_001141985.1_6259_7_14_genomic.fna -db /storage/bergid/antibiotic_resistance_db -out blast_results_example.txt

example query: 
       /storage/shared/ncbi_bacteria_assembly/GCA/001/141/985/GCA_001141985.1_6259_7_14/GCA_001141985.1_6259_7_14_genomic.fna.gz

------------------------------------------------------------------------------
gunzip file.fna.gz --> file.fna



chmod 777 catalognamn for att ge rattigheter
ln -s "katalog namn path" for att gora egen "fake" katalog till en annan plats typ storage.
90% sekvenslikhet/identity, 70 coverage resistencegenen (db)
tmux, ctrlb + d (deattach) for att kora kod lange
tmux a -t mysession (öppna en specifik session)
htop for att kolla minne osv
tmux list-sessions (lista alla dina sessions)
tmux rename-session -t <old-name> <new-name> (döpa om session)
tmux kill-session -t my_session (radera session)

blast output table: 
query acc.ver | subject acc.ver | % identity | alignment length | mismatches | gap opens | q. start | q. end | s. start | s. end | evalue | bit score

------------------------------------------------------------------
dataframe.iloc[0] --> first row in a dataframe

titta på endast headern: head -n 1 <filename>
titta specifik rad: sed -n '10p' <filename>
titta på specifka kolumner: cut -d',' -f2,5 <filename>

första 20 raderna och specifika kolumner: head -n 20 <file> | cut -f1,4,5,7,8,9,10,11,12,13 

grep -n "/storage/shared/ncbi_bacteria_assembly/GCA/000/760/415/GCA_000760415.1_ASM76041v1/GCA_000760415.1_ASM76041v1_genomic.fna.gz" /storage/shared/data_for_master_students/ida_and_ellen/genome_filepaths.tsv



'''