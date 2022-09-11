import os
import eyed3

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
    if os.path.isdir(PATH + album) and album != "Playlists" and album != "Ambient":
        artist = album[: album.find(" - ")]
        album_name = album[album.find(" - ") + 3 :]
        dico = {}
        for song in os.listdir(PATH + album):
            audiofile = eyed3.load(PATH + album + "/" + song)
            date = audiofile.tag.release_date
            if date in dico.keys():
                dico[date] += 1
            else:
                dico[date] = 1
            date = maxi_dict(dico)
        print("\n", artist, album_name, date)
        if not date:
            date = input("date?")
        for song in os.listdir(PATH + album):
            audiofile = eyed3.load(PATH + album + "/" + song)
            audiofile.tag.artist = artist
            audiofile.tag.album = album_name
            audiofile.tag.album_artist = artist
            if song.find(".mp3"):
                title = song[:-4]
            else:
                title = song
            audiofile.tag.title = title
            audiofile.tag.release_date = date
            audiofile.tag.recording_date = date
            audiofile.tag.year = date
            audiofile.tag.save()
