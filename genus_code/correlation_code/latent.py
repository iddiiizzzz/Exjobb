import pandas as pd

correlation_list = ""
latent_list = "/storage/bergid/dictionaries/args_latent_established.tsv"
results = ""

print("dictionary")
latent_dictionary = {}
with open(latent_list, "r") as dict:
    next(dict)
    for row in dict:
        row = row.strip().split("\t")
        name = row[0]
        status = row[1]
        latent_dictionary[name] = status


print("loop")
status_list = []
with open(correlation_list, "r") as corr:
    next(corr)
    for line in corr:
        line = line.strip().split()
        gene_name = line[0]
        status_gene = latent_dictionary.get(gene_name)
        status_list.append(status_gene)

df = pd.read_csv(correlation_list, sep = "\t")
df["Gene status"] = status_list

print("write")
df.to_csv(results, sep = "\t", index = False)