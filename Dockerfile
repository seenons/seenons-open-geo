FROM osrm/osrm-backend:latest
LABEL maintainer=raul@seenons.com

ARG continent=europe
ARG map=netherlands-latest

ENV CONTINENT=$continent
ENV MAP=$map

RUN apt update && apt install wget htop -y
WORKDIR /opt

COPY docker-entrypoint.sh .
COPY profiles/* .

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
EXPOSE 5000-5003
