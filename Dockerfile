FROM debian:bullseye-backports
MAINTAINER Jeremie Dufault <jeremie@jeremiedufault.ca>

RUN apt-get update
RUN apt-get install sqlite3 libc6 libcrypto++8 lsb-release libcurl4 libfuse2 wget btrfs-progs libcurl3-gnutls -y

RUN wget -O /root/urbackup.deb https://beta.urbackup.org/Server/2.5.18%20beta/urbackup-server_2.5.18_amd64.deb;

RUN DEBIAN_FRONTEND=noninteractive dpkg -i /root/urbackup.deb  || true

EXPOSE 55413
EXPOSE 55414
EXPOSE 55415
EXPOSE 35623

HEALTHCHECK  --interval=5m --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost:55414/ || exit 1

VOLUME [ "/var/urbackup", "/backup","/var/run/docker.sock"]
ENTRYPOINT ["/usr/bin/urbackupsrv"]
CMD ["run"]
