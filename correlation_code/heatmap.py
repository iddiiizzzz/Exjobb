
# --------------------------------------------
# Create a heatmap over the correlations
# --------------------------------------------

import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

correlations = "/storage/bergid/correlation/results_gene_correlation.tsv"
# correlations = "test_files/test_gene_correlation_results.tsv"


df = pd.read_csv(correlations, sep="\s+")
df.columns = df.columns.str.strip()
heatmap_data = df.pivot(index="Gene1", columns="Gene2", values = "CorrelationCoefficient")

plt.figure()
sns.heatmap(heatmap_data, annot=True, cmap="coolwarm", center=0)
plt.savefig("correlation_code/heatmap_all_genes.pdf", format="pdf", bbox_inches="tight")


