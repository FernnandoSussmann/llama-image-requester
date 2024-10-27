import requests
import cv2
import argparse
import pytesseract


parser = argparse.ArgumentParser(
                    prog='Llama text query requester',
                    description='Sends query as an image to llama to interpret',
                    epilog='')
parser.add_argument('--file_path', nargs='?', help="Path for the image that contains text") 
parser.add_argument('--llm_endpoint',
                    nargs='?',
                    help=(
                        "Llama server you will send your prompt."
                        " Local installation use: http://localhost:11434"
                    )
) 
parser.add_argument('--prompt',
                    nargs='?',
                    required=False,
                    help="LLM model prompt. Must contain {text} where extracted query will go in it",
                    default="Extract SQL command in the follwing text: {text}",
)
parser.add_argument('--pytesseract_instalation_path',
                    nargs='?',
                    default="/usr/bin/tesseract",
                    help="Path to tesseract installation. Default: /usr/bin/tesseract"
)
args = parser.parse_args()

path = args.file_path
llm_endpoint = args.llm_endpoint
config = ('-l eng --oem 1 --psm 3')

img = cv2.imread(path)
pytesseract.pytesseract.tesseract_cmd = args.pytesseract_instalation_path
text = pytesseract.image_to_string(img, config=config)

print(text)

prompt = args.prompt.format(text=text)

payload = { 
    "model": "codellama",
    "prompt": prompt,
    "stream": False,
}
res = requests.post(f"{llm_endpoint}/api/generate", json=payload)
print(res.json()["response"])
