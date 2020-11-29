# kinesis-bash

To run this demo, first ensure the following:

- `aws` CLI is installated and authorized to use Kinesis.
- [`jq`](https://stedolan.github.io/jq/) is installed.

Then execute ...
```
./producer.sh
```
... and follow the prompts to see how to invoke `consumer.sh`

**Be aware** that each invocation creates a new Kinesis data stream, so remember to clean these up after use.
