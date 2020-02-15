import re
import sys
import json
import time
import core.scanner as njsscan

outputfile = "/opt/results.json"

def runnodejsscan(scanpath):
    return njsscan.scan_dirs([scanpath])

def parsescanoutput(scanresult, executionTime):
    output = []
    seclist = scanresult['sec_issues']
    for key, value in seclist.items():
        for i in range(len(seclist[key])):
            issue = {"type": "sast", "ruleId": seclist[key][i]['title'], "location": {}}
            issue["location"]["path"] = re.sub(".*test-src/", "", seclist[key][i]['path'])
            issue["location"]["positions"] = {"begin": {"line": seclist[key][i]['line']}}
            issue["metadata"] = {"description": seclist[key][i]["description"]}
            output.append(issue)
    final = {"engine": {}}
    final["engine"]["name"] = "guardrails/engine-javascript-nodejsscan"
    final["engine"]["version"] = "1.0.0"
    final["process"] = {}
    final["process"]["name"] = "nodejsscan "
    final["process"]["version"] = njsscan.settings.VERSION
    final["language"] = "javascript"
    final["status"] = "success"
    final["executionTime"] = executionTime
    final["issues"] = scanresult['total_count']['sec']
    final["output"] = output
    json_object = json.loads(json.dumps(final))
    json_formatted_str = json.dumps(json_object, indent=2)
    fopen = open(outputfile, "w")
    fopen.writelines(json_formatted_str)
    fopen.close()
    print(json_formatted_str)

def main(scanpath):
    try:
        start_time = time.time()
        res_dir = runnodejsscan(scanpath)
        executetime = "--- %s milliseconds ---" % (int(round(time.time() - start_time) * 1000))
        executionTime = (int(round(time.time() - start_time) * 1000))
        parsescanoutput(res_dir, executionTime)
    except Exception as e:
        print(e)

if __name__ == "__main__":
    main(sys.argv[1])
