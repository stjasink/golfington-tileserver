#!/bin/bash

# Download data files

echo "Downloading latest full osm.pbf files"
curl http://download.geofabrik.de/europe/great-britain/england/greater-london-latest.osm.pbf -o greater-london-latest.osm.pbf
curl http://download.geofabrik.de/europe/france/midi-pyrenees-latest.osm.pbf -o midi-pyrenees-latest.osm.pbf
curl http://download.geofabrik.de/europe/france/aquitaine-latest.osm.pbf -o aquitaine-latest.osm.pbf
curl http://download.geofabrik.de/europe/spain-latest.osm.pbf -o spain-latest.osm.pbf

# Crop data files to areas required

echo "Cropping osm.pbf files to required regions only"
osmconvert greater-london-latest.osm.pbf -b=-0.159966,51.575021,-0.139865,51.589995 --complete-ways -o=hw.osm.pbf
osmconvert greater-london-latest.osm.pbf -b=-0.0959907444,51.463050569,-0.087991631,51.4690266996 --complete-ways -o=rp.osm.pbf
osmconvert midi-pyrenees-latest.osm.pbf -b=1.3610277617,43.0190290315,1.3670091046,43.0239583661 --complete-ways -o=co.osm.pbf
osmconvert midi-pyrenees-latest.osm.pbf -b=3.0339705559,44.0980111281,3.039070944,44.101963839 --complete-ways -o=pga.osm.pbf
osmconvert aquitaine-latest.osm.pbf -b=0.6770310221,45.6619901588,0.6820112249,45.6669781249 --complete-ways -o=gp.osm.pbf
osmconvert spain-latest.osm.pbf -b=1.5700086488,41.8752770828,1.5733788848,41.8789782623 --complete-ways -o=rm.osm.pbf

rm greater-london-latest.osm.pbf midi-pyrenees-latest.osm.pbf aquitaine-latest.osm.pbf spain-latest.osm.pbf

# convert to o5m format so that they can be merged

echo "Converting to o5m format"
osmconvert hw.osm.pbf --out-o5m -o=hw.o5m
osmconvert rp.osm.pbf --out-o5m -o=rp.o5m
osmconvert co.osm.pbf --out-o5m -o=co.o5m
osmconvert pga.osm.pbf --out-o5m -o=pga.o5m
osmconvert gp.osm.pbf --out-o5m -o=gp.o5m
osmconvert rm.osm.pbf --out-o5m -o=rm.o5m

rm hw.osm.pbf rp.osm.pbf co.osm.pbf pga.osm.pbf gp.osm.pbf rm.osm.pbf

# merge into single osm.pbf file

echo "Merging into single all.osm.pbf file"
osmconvert hw.o5m rp.o5m co.o5m pga.o5m gp.o5m rm.o5m --out-pbf -o=all.osm.pbf

rm hw.o5m rp.o5m co.o5m pga.o5m gp.o5m rm.o5m
