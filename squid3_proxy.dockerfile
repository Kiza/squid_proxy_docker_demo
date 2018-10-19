FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y apache2-utils
RUN apt-get install -y squid3

RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.default
COPY ./squid.conf /etc/squid/squid.conf

RUN touch /etc/squid/passwords

RUN htpasswd -b /etc/squid/passwords "username" "p@ssw0rd"

RUN touch /var/log/squid/access.log
RUN chmod 777 /var/log/squid/access.log
RUN touch /var/log/squid/cache.log
RUN chmod 777 /var/log/squid/cache.log
RUN touch /var/log/squid/store.log
RUN chmod 777 /var/log/squid/store.log

EXPOSE 3128/tcp

ENTRYPOINT service squid start && tail -f /var/log/squid/access.log
