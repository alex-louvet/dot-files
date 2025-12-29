import sys
import csv
import matplotlib.pyplot as plt

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
    plt.scatter([i for i in range(len(toplot[i]))],toplot[i],label=str(i+1))

plt.legend()
plt.show()
