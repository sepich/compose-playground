FROM ubuntu
MAINTAINER i@sepa.spb.ru
LABEL app="carbonapi"
LABEL version="170103"
LABEL github="https://github.com/dgryski/carbonapi"

ENV DEBIAN_FRONTEND noninteractive
ENV GOPATH=/opt/go
RUN apt-get update && apt-get -y install git golang && \
 go get -d github.com/dgryski/carbonapi && \
 cd ${GOPATH}/src/github.com/dgryski/carbonapi && \
 go build && mv carbonapi /usr/sbin/ && cd / && \
 apt-get -y purge golang git && apt -y autoremove && rm -rf ${GOPATH}

EXPOSE 8080
ENTRYPOINT [ "/usr/sbin/carbonapi" ]