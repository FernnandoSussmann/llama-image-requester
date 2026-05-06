#!/bin/bash

set_ollama_container () {
    ./docker_setup.sh
}

check_ollama_container() {
    OLLAMA_CONTAINER_EXISTS=$(docker ps --format '{{.Names}}' | grep ollama); echo $OLLAMA_CONTAINER_EXISTS

    if [[ "$OLLAMA_CONTAINER_EXISTS" == *"ollama"* ]]; then
    echo "Ollama container found."
    else
    echo "Ollama container is missing"
    option=""
    while [[ "$option" != [Yy] || $option == [Nn] ]]; do 
        read -p "Would you like to create ollama container? y/n: " option
        if [[ "$option" == [Yy] ]]; then
            set_ollama_container
        else
            echo "Ollama container is necessary. Shutting execution down"
            exit 1
        fi
    done
    fi
}

install_extra_images() {
    download=$1
    while [[ "$download" != "n" ]]; do
        echo "What is the name of the model you want to download?"
        echo "(Note: use the same name as you would in ollama pull. Example \`ollama pull qwen3.5:9b\`."
        echo "(Check https://ollama.com/search for model's name)"
        read -p "" model
        if [[ -z "$model" ]]; then
            echo "Please inform model's name"
        else
            docker exec ollama ollama pull $model
        fi
        read -p "Download another [y/n]: " download
    done
}

parameter_builder_and_runner() {
    read -p "Enter file_path (required): " file_path
    read -p "Enter llm_endpoint (required): " llm_endpoint
    read -p "Enter prompt [optional]: " prompt
    read -p "Enter pytesseract_installation_path [optional]: " pytesseract_installation_path

    if [[ -z "$file_path" ]] || [[ -z "$llm_endpoint" ]]; then
        echo "Error: file_path and llm_endpoint are required."
        exit 1
    fi

    # Construct the command with required parameters
    args="--file_path $file_path --llm_endpoint $llm_endpoint"

    # Add optional parameters if provided
    if [[ ! -z "$prompt" ]]; then
        args="$args --prompt $prompt"
    fi

    if [[ ! -z "$pytesseract_installation_path" ]]; then
        args="$args --pytesseract_installation_path $pytesseract_installation_path"
    fi

    # Execute the command
    ./run.sh $args
}

# main execution
echo "Welcome to Llama Image Requester!"

check_ollama_container

read -p "Would you like use another model (default: codellama) ? y/n: " download
install_extra_images $download

parameter_builder_and_runner
