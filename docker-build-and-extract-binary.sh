#!/bin/bash

image_tag=go-wol
source_path=/app/build
destination_path=./target

echo "Building ..."
docker build -t "$image_tag" .

# Extract files from image
# Fuente: https://unix.stackexchange.com/questions/331645/extract-file-from-docker-image
echo "Creating a new container from image, without starting it ..."
container_id=$(docker create "$image_tag")

echo "Extracting ..."
mkdir -p "$destination_path"
docker cp "$container_id:$source_path" "$destination_path"
docker rm "$container_id"

# Optional: remove image
# docker image rm "$image_tag"