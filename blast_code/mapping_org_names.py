import pandas as pd
from Bio import Entrez

blast = "/storage/bergid/blast/scov_pident_filtered_blast.txt"
mapping_file = "/storage/bergid/blast/blast_with_org_names.tsv"

# blast = "/home/bergid/Exjobb/test_files/blast_with_true_names_fixed.txt"
# mapping_file = "test_files/mapping_org_names.tsv"

# Read your results CSV into a DataFrame
df = pd.read_csv(blast, sep="\t")  # Adjust the separator if needed

# NCBI Entrez setup
Entrez.email = "bergid@chalmers.se"  # Always use your email when querying NCBI

# Function to fetch organism name for a given sequence ID
def fetch_organism(seqid):
    try:
        handle = Entrez.efetch(db="nucleotide", id=seqid, rettype="gb", retmode="text")
        record = handle.read()
        # Search for organism in GenBank record
        organism = None
        for line in record.splitlines():
            if line.startswith("  ORGANISM"):
                organism = line.split("  ")[-1]
                break
        return organism
    except Exception as e:
        print(f"Error fetching {seqid}: {e}")
        return None

# Apply function to map each sequence ID in your dataframe
df['Organism'] = df['qseqid'].apply(fetch_organism)

# Save the result to a new file
df.to_csv(mapping_file, index=False, sep="\t")
