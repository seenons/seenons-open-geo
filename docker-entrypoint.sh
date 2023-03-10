#!/bin/sh

#export CONTINENT=europe
#export MAP=netherlands-latest
#export MAP=malta-latest


if [ ! -f ${MAP}.osm.pbf ]
then
  echo "Building for "${CONTINENT}"/"${MAP}
  wget https://download.geofabrik.de/${CONTINENT}/${MAP}.osm.pbf -O ${MAP}.osm.pbf
  ## Truck
  echo ">>>>>>> Truck"
  mkdir truck && cd truck && cp ../${MAP}.osm.pbf .
  osrm-extract ${MAP}.osm.pbf -p ../truck.lua && osrm-contract ${MAP}.osrm

  ## Add Car
  # nano /profiles/car.lua
  echo ">>>>>>> Car"
  cd .. && mkdir car && cd car && cp ../${MAP}.osm.pbf .
  osrm-extract ${MAP}.osm.pbf -p ../car.lua && osrm-contract ${MAP}.osrm

  # NOTE: van profile currently not active
  # ## Add Van
  #echo ">>>>>>> Van"
  #cd .. && mkdir van && cd van && cp ../${MAP}.osm.pbf .
  #osrm-extract ${MAP}.osm.pbf -p ../van.lua && osrm-contract ${MAP}.osrm
  #osrm-routed ${MAP}.osm.pbf -p 5002 --max-table-size 500 &

  ## Add Cargo Bike
  echo ">>>>>>> Bike"
  cd .. && mkdir bike && cd bike && cp ../${MAP}.osm.pbf .
  osrm-extract ${MAP}.osm.pbf -p ../bike.lua && osrm-contract ${MAP}.osrm
  cd ..
fi

echo "Starting services "${CONTINENT}"/"${MAP}
cd truck
osrm-routed ${MAP}.osm.pbf -p 5000 --max-table-size 500 &
cd ../car
osrm-routed ${MAP}.osm.pbf -p 5001 --max-table-size 500 &
# cd ../van
# osrm-routed ${MAP}.osm.pbf -p 5002 --max-table-size 500 &
cd ../bike
osrm-routed ${MAP}.osm.pbf -p 5003 --max-table-size 500 &
child=$!
wait "$child"
