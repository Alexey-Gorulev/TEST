import os
from checksumdir import dirhash


CURRENT_DIR = os.getcwd()
TARGET_DIR = CURRENT_DIR + "/Folder_1"
#print(TARGET_DIR)
hash = dirhash(TARGET_DIR)
print(hash)