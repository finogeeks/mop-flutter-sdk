#!/bin/bash
set -e
#curl -X POST -H 'Content-Type: application/json' -H 'X-Gogs-Delivery:f29ac647-829a-4977-85b5-e4be037ec877' -H 'X-Gogs-Event:push' -d '{"secret": 123321}' http://218.17.115.160:9000/gogs-webhook/?job=FinChatSDK
curl --max-time 5 --connect-timeout 1 -X POST -H 'Content-Type: application/json' -H 'X-Gogs-Delivery:f29ac647-829a-4977-85b5-e4be037ec877' -H 'X-Gogs-Event:push' -d '{"secret": abcd@@1234}' https://jenkins.finogeeks.club/gogs-webhook/?job=mop-flutter-sdk

echo "trigger success."