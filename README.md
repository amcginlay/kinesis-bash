# kinesis-bash

To run this demo, first ensure `aws` CLI is installated and authenticated to use Kinesis.

Then execute ...
```
./producer.sh
```
... and follow the prompts to see how to invoke `consumer.sh`

**Be aware** that each invocation creates a new Kinesis data stream, so remember to clean these up after use.
