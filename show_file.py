import csv

file_path = "/storage/shared/data_for_master_students/ida_and_ellen/taxonomy_metagenomes.csv"

with open(file_path, "r") as file:
    reader = csv.reader(file)
    row_count = 0
    max_rows_to_display = 1 # Adjust the number of rows you want to display

    for row in reader:
        if row:  # Ensure the row is not empty
            print(row[1])  # Print only the first column
            row_count += 1
        if row_count == max_rows_to_display:
            break
