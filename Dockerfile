FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "wget"]
RUN wget https://repo.percona.com/apt/percona-release_0.1-4.jessie_all.deb
RUN dpkg -i percona-release_0.1-4.jessie_all.deb
RUN ["apt-get", "update"]
RUN apt-get install -y percona-xtradb-cluster-57 percona-xtradb-cluster-garbd-5.7
RUN ["apt-get", "install", "-y", "vim", "curl"]

COPY my.cnf /etc/mysql/
COPY garbd /etc/default/

VOLUME ["/var/lib/mysql", "/var/log/mysql"] # Make mysql data volumes

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 4444 4567 4568 4569

#______________
#| '_ \ \/ / __|
#| |_) >  < (__ 
#| .__/_/\_\___|
#|_|            

