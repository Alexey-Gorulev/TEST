import os
import checksumdir
CURRENT_DIR = os.getcwd()
TARGET_DIR = CURRENT_DIR + "/Folder_1"
#print(TARGET_DIR)
hash = checksumdir.dirhash(TARGET_DIR)
print hash