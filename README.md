# llama-image-requester
I created this script because often I receive a query as an image instead text. It would help me alot to extract the text from the image and send it to an LLM to pre-analyse it. This is not a robust project just an intresting script.

# How to run
## Setup
To run this project you must have:
- Python 3.10 or higher
- [Ollama](https://ollama.com) installed or an IA sever with llama models running in it
- [Tesseract](https://tesseract-ocr.github.io/tessdoc/Installation.html) installed
- [PyTesseract](https://pypi.org/project/pytesseract/) installed

This was developed using a local ollama server so if you use a different IA server the request part of the could probably need to change. If you are running it locally you must download `codellama` model `ollama pull codellama` and serve it running `ollama serve`. 

## Running
You can simply call this script using command line. For more information about it's parameters you can use the `--help` flag:
```sh
$ python llama_image_resquester.py --help
--help
usage: Llama text query requester [-h] [--file_path [FILE_PATH]] [--llm_endpoint [LLM_ENDPOINT]] [--prompt [PROMPT]]
                                  [--pytesseract_instalation_path [PYTESSERACT_INSTALATION_PATH]]

Sends query as an image to llama to interpret

options:
  -h, --help            show this help message and exit
  --file_path [FILE_PATH]
                        Path for the image that contains text
  --llm_endpoint [LLM_ENDPOINT]
                        Llama server you will send your prompt. Local installation use: http://localhost:11434
  --prompt [PROMPT]     LLM model prompt. Must contain {text} where extracted query will go in it
  --pytesseract_instalation_path [PYTESSERACT_INSTALATION_PATH]
                        Path to tesseract installation. Default: /usr/bin/tesseract
```


## Examples
With default values
```sh
python llama_image_resquester.py --file_path sql_image_example.png --llm_endpoint http://localhost:11434
SELECT * FROM CLIENTS

EXCEPTION: Query failed due missing access on column salary.


The SQL command in the given text is:

SELECT * FROM CLIENTS
```
With custom prompt
```sh
python llama_image_resquester.py --file_path sql_image_example.png --llm_endpoint http://localhost:11434 --prompt "Extract query from this {text}. Does this query makes sense? What I should do to tune it?"
SELECT * FROM CLIENTS

EXCEPTION: Query failed due missing access on column salary.



The query `SELECT * FROM CLIENTS` is valid and will retrieve all columns from the `CLIENTS` table. However, if you are experiencing an error saying "missing access on column salary," it means that your user account does not have permission to access the `salary` column in the `CLIENTS` table.

To resolve this issue, you should either grant your user account permissions to access the `salary` column or you can modify the query to only retrieve the columns that you are authorized to access. For example, if you only need to retrieve the `client_id` and `name` columns from the `CLIENTS` table, you could use a modified version of the query like this:
\`\`\`sql
SELECT client_id, name FROM CLIENTS;
\`\`\`
This will allow your user account to access only those columns that are explicitly specified in the query.
```
