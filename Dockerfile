FROM ubuntu:26.04

RUN echo "deb http://archive.ubuntu.com/ubuntu resolute universe" >> /etc/apt/sources.list
RUN apt update -y
RUN apt install tesseract-ocr libtesseract-dev -y
RUN apt install libgl1 -y

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY . .

RUN uv sync

ENTRYPOINT ["uv", "run", "python", "./llama_image_resquester.py"]
