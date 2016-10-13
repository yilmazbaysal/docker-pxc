FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "wget"]
RUN wget https://repo.percona.com/apt/percona-release_0.1-4.jessie_all.deb
RUN dpkg -i percona-release_0.1-4.jessie_all.deb
RUN ["apt-get", "update"]
RUN apt-get install -y percona-xtradb-cluster-garbd-5.7
RUN ["apt-get", "install", "-y", "vim", "curl"]

COPY garbd /etc/default/
