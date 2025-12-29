import csv
import sys

with open(sys.argv[1], mode ='r') as file:
    csvFile = csv.reader(file,delimiter=";")
    for lines in csvFile:
        print(lines)
