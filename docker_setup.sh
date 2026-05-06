#!/bin/bash

docker run -d -v ollama:/root/.ollama -p 11435:11434 --name ollama ollama/ollama
docker exec ollama ollama pull codellama
