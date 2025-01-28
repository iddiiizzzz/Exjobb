with open('/storage/koningen/nbci_taxonomy/nodes.dmp', 'r') as file:
    for i, line in enumerate(file):
        if i < 10:  # Check the first 10 lines
            print(repr(line))  # Use repr() to display any invisible characters