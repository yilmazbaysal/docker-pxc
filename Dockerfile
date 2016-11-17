FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "wget", "vim", "rsync"]
RUN ["apt-get", "install", "-y", "software-properties-common"]
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
RUN add-apt-repository 'deb [arch=amd64,i386] ftp://ftp.ulak.net.tr/pub/MariaDB/repo/10.2/debian jessie main'
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "mariadb-server"]

COPY my.cnf /etc/mysql
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 3306 4567 4568 4444
