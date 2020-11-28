#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "missing arg, please pass numerical stream identifier"
    exit -1
fi

stream_name=data_${1}

echo "waiting: ${stream_name}"
aws kinesis wait stream-exists --stream-name ${stream_name}

echo "consuming: ${stream_name} (ctrl+c to end)"
iterator=$(aws kinesis get-shard-iterator --stream-name ${stream_name} --shard-id 0 --shard-iterator-type TRIM_HORIZON --query '[ShardIterator]' --output text)
for (( c=1; ; c++ )); do
  echo "iteration: ${c}"
  results=$(aws kinesis get-records --shard-iterator ${iterator})
  iterator=$(echo ${results} | jq .NextShardIterator --raw-output)  
  echo ${results} | jq '.Records[].Data' --raw-output | while read data; do
    echo $(base64 --decode <<< ${data})
  done
done
