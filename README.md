# Dockerized NodeJSScan Container


This repository will create Dockerized container whiich contains scna file written in Python3 to scan vulnerable code of NodeGoat from /opt/test-src/ folder.
The scan result is parsed and converted into JSON file in following format.

Docker image with name "guardrails" and container with "guardrails_container" will be created using this script.

## Directory Structure

```bash
├── <source files>
├── test-src/
├── tools/
├── Dockerfile
└── README.md # documentation for this repo
```

- The **test-src** file contains source code NodeGoat.
- Tools directory contains build.sh, run.sh and install_tzdata.sh
  - **build.sh** script will create docker image "guardrails" and then the container "guardrails_container" is started.
  - **run.sh** script contains the steps required to install npm packages and other packages that are required for installing NodeGoat
  - **install_tzdata.sh** script is used to install tzdata package uninteractively. This package gets installed while installing one of the dependencies, but it is interactive installation. So to make the docker image creation full automatic, I have added install_tzdata.sh to install tzdata package uninteractively.
- **Dockerfile** is used to download Ubuntu 18.04 and create docker image "guardrails"
- **ParseScanResult.py** file the parser file which is used to launch NodeJSScan against NodeGoat source code and parse the NodeJSScan results in required JSON file.
- **mongodb-org-4.2.list** file is used for updating local repo list for installation of mongodb locally (Mongo DB is used by NodeGoat)

## How to Run
- Install docker on your host
- Create docker user and add it in docker group.
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
$ sh build.sh
```
- This will create dockerized container image "guardrails" and start the container "guardrails_container".

- Connect to "guardrails_container" using following command

```bash
$ docker exec -it guardrails_container bash
```

- Now run the ParseScanResult.py file from /opt/ by giving path to the static code that needs to be scan. In my case the location is /opt/test-src, so the mamand is as follows:

```bash
$ python3.6 /opt/ParseScanResult.py /opt/test-src/
```

- This will create results.json file at localtion /opt/results.json
```bash
$ cat /opt/results.json
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
