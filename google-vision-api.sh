#!/bin/bash -xe
# Date: Mar 19, 2020
# Author: cplus.shen@gmail.com
# Description: Use Google Vision API to analysis the picture
# 
# Key Path: /home/ubuntu/soph/key/soph-e62db716410e.json
# Parameter: Picture filename
# Return: 
#         999: failed
#         others: passed 

export GOOGLE_APPLICATION_CREDENTIALS=/home/ubuntu/soph/key/project-id.json
export PYTHONIOENCODING=utf8

if [ x"$1" == "x" ]; then
  echo "Usage: $0 filename"
  exit 999 
fi

openssl base64 -A -in $1 -out $1.base64 

BASE64=$(cat $1.base64)
sed  "s|IMAGE_CONTENT|$BASE64|g" "request.json.template" > request.json

curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
https://vision.googleapis.com/v1/images:annotate -d @request.json --output response.json

X=$(cat response.json |  python2 -c "import sys, json; print json.load(sys.stdin)['responses'][0]['fullTextAnnotation']['text']")
LC=$(echo $X | wc | awk '{print $1}')
if [ $LC -gt 1 ]; then
  exit 999 
fi

X=$(echo $X | sed 's/x/*/g' | awk -F '=' '{print $1}' | bc )

if [ x$X = "x" ]; then
  exit 999 
fi

rm -f request.json
rm -f $1.base64
rm -f response.json

exit $X
