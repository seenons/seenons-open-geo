FROM osrm/osrm-backend:latest
LABEL maintainer=raul@seenons.com

ARG continent=europe
ARG map=netherlands-latest

ENV CONTINENT=$continent
ENV MAP=$map

RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
RUN sed -i 's|security.debian.org|archive.debian.org/|g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt update && apt install wget htop -y
WORKDIR /opt

COPY docker-entrypoint.sh .
COPY profiles/* .

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
EXPOSE 5000-5003
