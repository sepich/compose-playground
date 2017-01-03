FROM ubuntu
MAINTAINER i@sepa.spb.ru
LABEL app="go-carbon"
LABEL version="0.9.0-rc1"
LABEL github="https://github.com/lomik/go-carbon"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install wget && \
 wget https://github.com/lomik/go-carbon/releases/download/v0.9.0-rc1/go-carbon_0.9.0-rc1_amd64.deb && \
 dpkg -i go-carbon_0.9.0-rc1_amd64.deb && rm -r /var/cache go-carbon_0.9.0-rc1_amd64.deb

EXPOSE 2003/udp 2004 7002 8080
ENTRYPOINT [ "/usr/sbin/go-carbon" ]