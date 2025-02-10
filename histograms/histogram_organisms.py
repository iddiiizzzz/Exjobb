import numpy as np
import matplotlib.pyplot as plt
import csv

# File path
tax_count = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"

# List to store histogram data (incrementally)
bin_counts = {}

# Open CSV file and read values
with open(tax_count, "r") as file:
    reader = csv.reader(file)  # Read CSV file
    next(reader)  # Skip header row

    for row in reader:
        for value in row:
            value = value.strip()  # Remove spaces
            
            # Debug: Print first few values to understand their structure
            if len(value) > 0:
                print(f"Value read: {value}")  # Show non-empty values
            
            if value == "":  # If empty (e.g., ,,), treat as zero
                value = 0
            else:
                try:
                    # Try converting to float first (handle cases like "0.0", "1.5")
                    value = float(value)
                    # If the value is essentially an integer (e.g., "1.0"), cast it to int
                    if value.is_integer():
                        value = int(value)
                except ValueError:
                    print(f"Non-numeric value skipped: {value}")  # Debug non-numeric values
                    continue  # Skip non-numeric values

            # Add value to the bin counts (use a dictionary to keep track of counts)
            if value in bin_counts:
                bin_counts[value] += 1
            else:
                bin_counts[value] = 1

# Prepare data for plotting
if bin_counts:
    values = np.array(list(bin_counts.keys()))
    frequencies = np.array(list(bin_counts.values()))

    # Plot histogram
    plt.figure(figsize=(8, 5))
    plt.bar(values, frequencies, edgecolor='black')

    plt.xlabel("Count Value")
    plt.ylabel("Frequency")
    plt.title("Histogram of Count Matrix Values")
    plt.xticks(range(min(10, int(values.max()) + 1)))  # Limit x-axis ticks to prevent clutter
    plt.xlim([1,100]) #dont chow zeros
    #plt.ylim([0,50000])

    # Save the figure
    plt.savefig("histogram_organisms_optimized.png")

    print(f"Processed {sum(frequencies)} values for the histogram.")
else:
    print("No valid data found for the histogram.")
