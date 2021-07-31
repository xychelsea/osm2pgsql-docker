# OpenStreetMap Importing to PostGIS with osm2pgsql and Docker

Example run script

```bash
#!/bin/bash

OSM2PGSQL_NAME="osm2pgsql"
OSM2PGSQL_PATH="/path/to/dir/on/host"

OSM_NAME="openstreetmap"
OSM_NETWORK="primary"
OSM_USERNAME="openstreetmap"
OSM_DATABASE="openstreetmap"
OSM_PASSWORD="pamteertsnepo"
OSM_PORT="5432"
OSM_CACHE="10240"
OSM_NUM_PROCESSES="8"
OSM_STRATEGY="dense"
OSM_FLAT_NODES="nodes.cache"
OSM_INPUT_TYPE="pbf"
OSM_OUTPUT_TYPE="pgsql"
OSM_INPUT_FILE="planet-latest.osm.pbf"

docker run \
	--interactive \
	--hostname=${OSM2PGSQL_NAME} \
	--name=${OSM2PGSQL_NAME} \
	--net-alias=${OSM2PGSQL_NAME} \
	--network=${OSM_NETWORK} \
	--tty \
	--rm \
	--volume ${OSM2PGSQL_PATH}:/var/data \
       	xychelsea/osm2pgsql:v0.1 osm2pgsql \
		--cache=${OSM_CACHE} \
		--cache-strategy=${OSM_STRATEGY} \
		--create \
		--database=${OSM_DATABASE} \
		--flat-nodes=/var/data/${OSM_FLAT_NODES} \
		--host=${OSM_NAME} \
		--hstore \
		--input-reader=${OSM_INPUT_TYPE} \
		--keep-coastlines \
		--number-processes=${OSM_NUM_PROCESSES} \
		--output=${OSM_OUTPUT_TYPE} \
		--password \
		--port=${OSM_PORT} \
		--slim \
		--style=/var/data/${OSM_STYLE} \
		--username=${OSM_USERNAME} \
		--verbose \
		/var/data/${OSM_INPUT_FILE}
'''
