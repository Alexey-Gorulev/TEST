FROM openjdk:8-jdk-alpine3.9
ENV PASSWORD C4zGnxyCm8d6B5j8
RUN mkdir /src && \
    cd /src && \
    apk update && \
    apk add --no-cache procps unzip wget bash curl && \
    wget https://dlcdn.apache.org/knox/1.6.0/knox-1.6.0.zip && \
    unzip knox-1.6.0.zip && \
    mv knox-1.6.0 /knox-1.6.0 && \
    cd /knox-1.6.0 && \
    rm -r /src && \
    rm -r /knox-1.6.0/conf/topologies && \
    rm /knox-1.6.0/conf/gateway-site.xml && \
    /knox-1.6.0/bin/knoxcli.sh create-master --master $PASSWORD && \
    printf "$PASSWORD\n$PASSWORD" | adduser knox && \
    chown -R knox:knox /knox-1.6.0
COPY gateway-site.xml /knox-1.6.0/conf/gateway-site.xml
COPY topologies /knox-1.6.0/conf/topologies
WORKDIR /knox-1.6.0
USER knox
CMD /knox-1.6.0/bin/ldap.sh start && /knox-1.6.0/bin/gateway.sh start && tail -f /knox-1.6.0/logs/*
