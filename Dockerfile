FROM ubuntu:20.04 as converter

RUN apt-get update && apt-get install -y osmctools curl

COPY fetch-and-convert.sh /root/fetch-and-convert.sh
RUN cd /root && ./fetch-and-convert.sh

FROM overv/openstreetmap-tile-server:v1.8.2 as importer

COPY --from=converter /root/all.osm.pbf /data.osm.pbf
COPY all.poly /all.poly
RUN chmod 644 /data.osm.pbf /all.poly

ENV UPDATES=enabled

RUN ./run.sh import

FROM overv/openstreetmap-tile-server:v1.8.2

COPY --from=importer /var/lib/postgresql/12/main /var/lib/postgresql/12/main
COPY --from=importer /var/lib/mod_tile /var/lib/mod_tile
