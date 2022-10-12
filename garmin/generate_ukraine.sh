#!/bin/bash
MKGMAP="mkgmap-r4905" # adjust to latest version (see www.mkgmap.org.uk)
SPLITTER="splitter-r652"

mkdir tools
pushd tools > /dev/null

if [ ! -d "${MKGMAP}" ]; then
    wget "http://www.mkgmap.org.uk/download/${MKGMAP}.zip"
    unzip "${MKGMAP}.zip"
fi
MKGMAPJAR="$(pwd)/${MKGMAP}/mkgmap.jar"

if [ ! -d "${SPLITTER}" ]; then
    wget "http://www.mkgmap.org.uk/download/${SPLITTER}.zip"
    unzip "${SPLITTER}.zip"
fi
SPLITTERJAR="$(pwd)/${SPLITTER}/splitter.jar"

popd > /dev/null

if stat --printf='' bounds/bounds_*.bnd 2> /dev/null; then
    echo "bounds already downloaded"
else
    echo "downloading bounds"
    rm -f bounds.zip  # just in case
    wget "http://osm.thkukuk.de/data/bounds-latest.zip"
    unzip "bounds-latest.zip" -d bounds
fi

BOUNDS="$(pwd)/bounds"

if stat --printf='' sea/sea_*.pbf 2> /dev/null; then
    echo "sea already downloaded"
else
    echo "downloading sea"
    rm -f sea.zip  # just in case
    wget "http://osm.thkukuk.de/data/sea-latest.zip"
    unzip "sea-latest.zip" -d sea
fi

SEA="$(pwd)/sea/sea"
DATA_DIR=/home/garminotm/garmin_world
DEM_FILE=$DATA_DIR/dem/viewfinderpanoramas.zip


###############3


mkdir data
pushd data > /dev/null

rm -f ukraine-latest.osm.pbf
wget "https://download.geofabrik.de/europe/ukraine-latest.osm.pbf"

rm -f 6324*.pbf
java -jar $SPLITTERJAR --precomp-sea=$SEA "$(pwd)/ukraine-latest.osm.pbf"
DATA="$(pwd)/6324*.pbf"

popd > /dev/null

OPTIONS="$(pwd)/opentopomap_options"
STYLEFILE="$(pwd)/style/opentopomap"

pushd style/typ > /dev/null

java -jar $MKGMAPJAR --family-id=35 --dem=$DEM_FILE opentopomap.txt
TYPFILE="$(pwd)/opentopomap.typ"

popd > /dev/null

java -jar $MKGMAPJAR -c $OPTIONS --style-file=$STYLEFILE \
    --precomp-sea=$SEA \
    --max-jobs=10 \
    --output-dir=output --bounds=$BOUNDS $DATA $TYPFILE

# optional: give map a useful name:
mv output/gmapsupp.img output/ukraine.img