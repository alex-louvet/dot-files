import os

PATH = "/home/alexandre/Music/"


def maxi_dict(dicto):
    maxi = 0
    key_max = ""
    for key in dicto.keys():
        if dicto[key] > maxi:
            key_max = key
            maxi = dicto[key]
    return key_max


for album in os.listdir(PATH):
    dicto = {}
    temp_alb = album.find("Album - ")
    if temp_alb > -1:
        for song in os.listdir(PATH + album):
            temp = song.find(" - ")
            if temp > 0:
                if song[:temp] in dicto:
                    dicto[song[:temp]] += 1
                else:
                    dicto[song[:temp]] = 1
                print("renaming:", song, " in ", song[temp + 3 :])
                os.rename(
                    PATH + album + "/" + song, PATH + album + "/" + song[temp + 3 :]
                )

        if len(dicto.values()) > 0 and max(dicto.values()) > 1:
            print("renaming", album, " in ", maxi_dict(dicto) + album[5:])
            os.rename(PATH + album, PATH + maxi_dict(dicto) + album[5:])
