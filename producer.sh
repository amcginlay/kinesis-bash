#!/bin/bash

stream_id=${1:-${RANDOM}}
outer_range=${2:-10}
inner_range=${3:-25}
sleep_duration=${4:-2}

stream_name=data_${stream_id}

echo "----------------------------------------------------------"
echo "start './consumer.sh ${stream_id}' in another terminal session"
echo "----------------------------------------------------------"
echo

echo "checking for: ${stream_name}"
if aws kinesis describe-stream --stream-name ${stream_name} > /dev/null 2>&1; then
  echo "deleting: ${stream_name}"
  aws kinesis delete-stream --stream-name ${stream_name}
  aws kinesis wait stream-not-exists --stream-name ${stream_name}
  echo "deleted: ${stream_name}"
fi
echo "creating: ${stream_name}"
aws kinesis create-stream --stream-name ${stream_name} --shard-count 1
aws kinesis wait stream-exists --stream-name ${stream_name}
echo "created: ${stream_name}"

echo "putting records in: ${stream_name}"
for outer in $(seq ${outer_range}); do
  records=""
  for inner in $(seq ${inner_range}); do
    record="Data=$(base64 <<< ${outer}.${inner}),PartitionKey=${RANDOM}"
    records="${records} ${record}"
  done
  echo "producing batch: ${outer}"
  aws kinesis put-records --stream-name ${stream_name} --records ${records} > /dev/null 2>&1
  echo "sleeping for ${sleep_duration} seconds"
  sleep ${sleep_duration}
done
