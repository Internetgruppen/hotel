FROM debian:stretch

# Install basic extensions
RUN apt-get update && \
  apt-get install -y \
    proftpd proftpd-mod-mysql \
    ftp ncftp \
    mysql-client \
    pwgen \
  && apt-get -y autoremove && apt-get clean
RUN rm -fr /var/lock && rm -fr /var/run
RUN mkdir -p /var/hotel/home
