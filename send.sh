#!/bin/bash

cat <<EOF | curl -H'Content-Type: application/json' -XPOST localhost:4318/v1/metrics -d@- -i && echo
{
    "resourceMetrics": [{
        "scopeMetrics": [{
            "metrics": [{
                "name": "teamcity_agent_state",
                "gauge": {
                    "dataPoints": [{
                        "asDouble": 1,
                        "timeUnixNano": `date +%s`000000000,
                        "attributes": [{"key": "label", "value": {"stringValue": "val"}}]
                    }]
                }
            }]
        }]
    }]
}
EOF