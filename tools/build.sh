#!/bin/bash

start=`date +%s`
docker build -t guardrails ../
docker run -dt -P --name guardrails_container guardrails
end=`date +%s`

runtime=$((end-start))
echo $runtime
