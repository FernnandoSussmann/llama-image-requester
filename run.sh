#!/bin/bash

IMAGE_NAME=llama-image-requester
PROJECT_IMAGE=$(docker image ls --format "{{.Repository}}" | grep $IMAGE_NAME)

if [[ -z "$PROJECT_IMAGE" ]]; then
    docker build -t $IMAGE_NAME .
fi

docker run --link ollama llama-image-requester $@
