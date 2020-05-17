import os
import jenkins
from checksumdir import dirhash
import time


JENKINS_URL = "http://54.243.7.9:8080"
JENKINS_USERNAME = "jenkins"
JENKINS_PASSWORD = "56a537a6ece74098a0d802036494859d"
NAME_OF_JOB = "test_pipeline"
TOKEN_NAME = "GO_BUILD"
SUB_DIR = "/Folder_1"


class DevOpsJenkins:
    def __init__(self):
        self.jenkins_server = jenkins.Jenkins(JENKINS_URL, username=JENKINS_USERNAME, password=JENKINS_PASSWORD)
        user = self.jenkins_server.get_whoami()
        version = self.jenkins_server.get_version()
        print ("Jenkins Version: {}".format(version))
        print ("Jenkins User: {}".format(user['id']))

    def build_job(self, name, parameters=None, token=None):
        next_build_number = self.jenkins_server.get_job_info(name)['nextBuildNumber']
        self.jenkins_server.build_job(name, token=token)
        time.sleep(10)
        build_info = self.jenkins_server.get_build_info(name, next_build_number)
        return build_info


CURRENT_DIR = os.getcwd()
TARGET_DIR = CURRENT_DIR + SUB_DIR
#print(TARGET_DIR)
NEW_HASH = dirhash(TARGET_DIR)
#print(NEW_HASH)

FILE = open("/tmp/SHA_OF_TARGET_FOLDER.txt","r+")
OLD_HASH = FILE.readline()
FILE.close()

if OLD_HASH == NEW_HASH:
    print("SHA is identical")
else:
    print("SHA isn't identical")
    FILE = open("/tmp/SHA_OF_TARGET_FOLDER.txt","w+")
    FILE.write(NEW_HASH)
    FILE.close()
    jenkins_obj = DevOpsJenkins()
    output = jenkins_obj.build_job(NAME_OF_JOB, TOKEN_NAME)
    print ("Jenkins Build URL: {}".format(output['url']))