by default user is "knox"

by default nifi host is "https://nifi:9443/"
---
password for knox user and master-password knox "./Dockerfile, line 2"

nifi host "./topologies/sandbox.xml, line 85"

example user config "./users.ldif"
---
Run docker: "docker run -d -v $(pwd)/users.ldif:/knox-1.6.0/conf/users.ldif --net=host --name=knox knox"

Get access to NIFI "https://<server ip address>:8443/gateway/sandbox/nifi-app/nifi"
