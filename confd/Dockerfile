FROM alpine
ENTRYPOINT ["/usr/local/bin/confd"]
RUN apk update && apk add docker
ADD bin/confd-0.9.0-linux-amd64 /usr/local/bin/confd
#ADD confd-config /etc/confd
#VOLUME /etc/cassandra
