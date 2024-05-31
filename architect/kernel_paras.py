from os import listdir

file = listdir("/boot/loader/entries/")
print(file[1])
