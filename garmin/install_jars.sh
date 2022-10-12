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
