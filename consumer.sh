#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "missing arg, please pass numerical stream identifier"
    exit -1
fi

stream_name=data_${1}

# make sure you enter the stream id correctly or you'll be stuck here for a while ...
echo "waiting for stream ${stream_name}"
aws kinesis wait stream-exists --stream-name ${stream_name}

echo "consuming from stream ${stream_name} (ctrl+c to end)"
iterator=$(aws kinesis get-shard-iterator --stream-name ${stream_name} --shard-id 0 --shard-iterator-type TRIM_HORIZON --query '[ShardIterator]' --output text)
for (( c=1; ; c++ )); do
  echo "iteration: ${c}"
  results=$(aws kinesis get-records --shard-iterator ${iterator})
  iterator=$(echo ${results} | jq .NextShardIterator --raw-output)  
  echo ${results} | jq '.Records[].Data' --raw-output | while read data; do
    echo "consumed record $(base64 --decode <<< ${data})"
  done
done
