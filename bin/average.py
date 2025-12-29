import sys
import csv

toplot = []
with open(sys.argv[1], newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')
    for row in spamreader:
        for i,x in enumerate(row):
            if len(toplot) > i:
                toplot[i].append(float(x))
            else:
                toplot.append([float(x)])

for i in range(len(toplot)):
    print(1/len(toplot[i])*sum(toplot[i]))


