# Seenons Geo Engine
This repository holds the Dockerfiles to setup and update the geocoding and data matrix services based on OSRM.

Note:
- intended for Ubuntu 20.04
- Minimum of 8GB RAM is recommended (depending on the map)

## Services
- OSRM: Routing engine, distance & duration matrices

# Seenons Geo Engine on Docker image

Based on [Official OSRM docker image](https://hub.docker.com/r/osrm/osrm-backend). 

Notes:

* Supports any map from [Geofabrik](https://download.geofabrik.de/) 
* Built using ```ARG```:
  * ```continent``` default as ```europe```
  * ```map``` default as ```netherlands-latest```
  * See building & running instructions below
* This give us the opportunity of store several docker images based on countries/regions
  * ```seenons/geo:netherlands-latest```
  * ```seenons/geo:germany-latest```
  * etc.
* The instance requirements will vary depending on the size of the map
* `profiles` folder contains some custom profiles. Original configurations could be found in [OSRM repository](https://github.com/Project-OSRM/osrm-backend/tree/master/profiles).
 

## Services

* OSRM: Routing engine, distance & duration matrices
* Ports from `5000` to `5003` will serve the different profiles in `profile` folder 

## Building and Running

For the full list of continents/maps available please visit [Geofabrik](https://download.geofabrik.de/). 


Example with `--build-args` `continent=europe` and `map=netherlands-latest`:

```
# 1. Build docker image 
docker build --no-cache --progress=plain --build-arg continent=europe --build-arg map=netherlands-latest -t seenons/geo:latest -f Dockerfile .

# 2. Run container
docker run -d --name geo -p 5000-5003:5000-5003 seenons/geo:latest 

# Curl it!
curl "http://127.0.0.1:5000/route/v1/driving/4.8829509,52.368443;4.8831557,52.3684307?steps=true"
```