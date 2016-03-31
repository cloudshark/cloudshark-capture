#!/bin/bash

prompt="y"
cloudshark_url="https://www.cloudshark.org"
api_token="<INSERT API TOKEN HERE>"
dumpcap="/usr/bin/dumpcap"

# default values if not prompting
tmp_dir="/tmp/"
tmp_filename="traffic-$(date +%F-%H%M%S).pcapng"
filename=$tmp_filename
additional_tags=""

# trap SIGINT so we can interupt and still upload
trap '' 2

# start a curl upload
$dumpcap $@ -w ${tmp_dir}${tmp_filename}
if [ $? -ne 0 ]; then
  exit $?
fi

if [ "$prompt" == "y" ]; then
  echo -n "Send to CloudShark via ${cloudshark_url} (y|n=default) "
  read result
  if [ "$result" != "y" ]; then
    exit 0
  fi
  echo -n "Additional Tags? (optional) "
  read input
  if [ "$input" != "" ]; then
    additional_tags=$input
  fi
  echo -n "Capture Name? (optional) "
  read input
  if [ "$input" != "" ]; then
    filename=$input
  fi
fi

response=$(curl -s -F file="@${tmp_dir}${tmp_filename}" \
  -F filename="${filename}" \
  -F additional_tags="${additional_tags}" \
  ${cloudshark_url}/api/v1/${api_token}/upload)

json_id=$(echo $response | python -m json.tool | grep id)

if [ "$json_id" != "" ]; then

 # find the CloudShark ID for this session
 id=`echo $json_id | sed 's/:/ /1' | awk -F" " '{ print $2 }'| sed 's/\"//g'`

 # show a URL using the capture session in CloudShark
 echo "A new CloudShark session has been created at:"
 echo "${cloudshark_url}/captures/$id"

 # remove the temporary capture
 rm ${tmp_dir}${tmp_filename}
else
  echo "Could not upload capture to CloudShark:"
  echo $response | python -m json.tool
fi
