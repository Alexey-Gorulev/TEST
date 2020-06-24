from django.shortcuts import render
import socket
from django.http import HttpResponse
import os


node_name = os.environ.get('MY_NODE_NAME')
pod_name = os.environ.get('MY_POD_NAME')
pod_namespace = os.environ.get('MY_POD_NAMESPACE')
pod_ip = os.environ.get('MY_POD_IP')
pod_service_account = os.environ.get('MY_POD_SERVICE_ACCOUNT')


def index(request):
    return HttpResponse("<center><h1>Simple Site for Kubernetes<br>Container info</center></h1><br>"
                        "<h2>Node name is: " + str(node_name) +
                        "<br>Pod name is: " + str(pod_name) +
                        "<br>Pod namespace is: " + str(pod_namespace) +
                        "<br>Pod IP is: " + str(pod_ip) +
                        "<br>Pod service account: " + str(pod_service_account) + "</h2>" +
                        "<h1><br><center>Version 1</center></h1>")





#host_name = socket.gethostname()
#host_ip_address = socket.gethostbyname(host_name)
#"<h2>Host name is: " + str(host_name) + "</h2><br>"
#"<h2>Host IP address is: " + str(host_ip_address) + "</h2><br>"
