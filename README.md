# Dockerized NodeJSScan Container


This repository will create Dockerized container whiich contains scna file written in Python3 to scan vulnerable code of NodeGoat from /opt/test-src/ folder.
The scan result is parsed and converted into JSON file in following format.


## Directory Structure

```bash
├── <source files>
├── test-src/
├── tools/
├── Dockerfile
└── README.md # documentation for this repo
```

- The **test-src** file contains source code NodeGoat.
- Tools directory contains build.sh and run.sh
  - **build.sh** script will create docker image "guardrails" and then the container "guardrails_container" is started.
  - **run.sh** script contains the steps required to install npm packages and other packages that are required for installing NodeGoat
- **Dockerfile** is used to download Ubuntu 18.04 and create docker image "guardrails"
- **ParseScanResult.py** file the parser file which is used to launch NodeJSScan against NodeGoat source code and parse the NodeJSScan results in required JSON file.
- **mongodb-org-4.2.list** file is used for updating local repo list for installation of mongodb locally (Mongo DB is used by NodeGoat)

## How to Run
- Clone git repository

```bash
git clone https://github.com/shounakitraj/nodejsscan_container.git
```
- Go to nodejsscan_container/tools directory
```bash
$ cd nodejsscan_container/tools
```
- Run build.sh using following command

```bash
$ sudo sh build.sh
```
- This will create dockerized container image "guardrails" and start the container "guardrails_container".

- Connect to "guardrails_container" using following command

```bash
$ sudo docker exec -it guardrails_container bash
```

- Now run the ParseScanResult.py file from /opt/ using following command

```bash
# python3.6 /opt/ParseScanResult.py
```

- This will create results.json file at localtion /opt/results.json
```bash
# cat /opt/results.json
{
  "engine": {
    "name": "guardrails/engine-javascript-nodejsscan",
    "version": "1.0.0"
  },
  "process": {
    "name": "nodejsscan ",
    "version": "3.7"
  },
  "language": "javascript",
  "status": "success",
  "executionTime": 224000,
  "issues": 75,
  "output": [
    {
      "type": "sast",
      "ruleId": "Open Redirect",
      "location": {
        "path": "app/views/tutorial/a10.html",
        "positions": {
          "begin": {
            "line": 37
          }
        }
      },
      "metadata": {
        "description": "Untrusted user input in redirect() can result in Open Redirect vulnerability"
      }
    }
  ]
}
```
