import os
import sys

path = sys.argv[1]


def maxi_dict(dicto):
    maxi = 0
    key_max = ""
    for key in dicto.keys():
        if dicto[key] > maxi:
            key_max = key
            maxi = dicto[key]
    return key_max


for song in os.listdir(path):
    if len(song) > 16 and song[-16] == "-":
        print("renaming:", song, " in ", song[:-16] + ".mp3")
        os.rename(
            path + "/" + song, path + "/" + song[:-16] + ".mp3"
        )
