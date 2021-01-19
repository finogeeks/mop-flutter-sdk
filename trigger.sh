#!/bin/bash
set -e

curl --location --request POST 'https://jenkins.finogeeks.club/gogs-webhook/?job=mop-flutter-sdk' \
--header 'Content-Type: application/json' \
--header 'X-Gogs-Delivery: 27ea7f4d-2778-4a01-bb69-406d063eb16b' \
--header 'X-Gogs-Event: push' \
--header 'X-Gogs-Signature: 35174c0a630bc2de140e8fbb9ce6fb60b39385fd1b72efaba304fe6609bdf9bf' \
--header 'Cookie: JSESSIONID.26488c4e=node01jpx6whum04n91ted4v0x1pf976.node0' \
--data-raw '{
  "ref": "refs/heads/master",
  "before": "20e38c1c89da87a454a1f41ccce2e4a4c409a8b8",
  "after": "20e38c1c89da87a454a1f41ccce2e4a4c409a8b8",
  "compare_url": "",
  "commits": [
    {
      "id": "20e38c1c89da87a454a1f41ccce2e4a4c409a8b8",
      "message": "fix\n",
      "url": "https://git.finogeeks.club/mop-mobile/mop-flutter-sdk/commit/20e38c1c89da87a454a1f41ccce2e4a4c409a8b8",
      "author": {
        "name": "developer",
        "email": "developer@finogeeks.com",
        "username": ""
      },
      "committer": {
        "name": "developer",
        "email": "developer@finogeeks.com",
        "username": ""
      },
      "added": null,
      "removed": null,
      "modified": [
        "CHANGELOG.md",
        "example/.flutter-plugins-dependencies",
        "example/pubspec.lock",
        "pubspec.yaml"
      ],
      "timestamp": "0001-01-01T00:00:00Z"
    }
  ],
  "repository": {
    "id": 2487,
    "owner": {
      "id": 294,
      "username": "mop-mobile",
      "login": "mop-mobile",
      "full_name": "",
      "email": "",
      "avatar_url": "https://git.finogeeks.club/avatars/294"
    },
    "name": "mop-flutter-sdk",
    "full_name": "mop-mobile/mop-flutter-sdk",
    "description": "",
    "private": true,
    "fork": false,
    "parent": null,
    "empty": false,
    "mirror": false,
    "size": 4198400,
    "html_url": "https://git.finogeeks.club/mop-mobile/mop-flutter-sdk",
    "ssh_url": "git@git.finogeeks.club:mop-mobile/mop-flutter-sdk.git",
    "clone_url": "https://git.finogeeks.club/mop-mobile/mop-flutter-sdk.git",
    "website": "",
    "stars_count": 0,
    "forks_count": 0,
    "watchers_count": 4,
    "open_issues_count": 0,
    "default_branch": "master",
    "created_at": "2020-04-13T10:51:01+08:00",
    "updated_at": "2021-01-19T22:37:20+08:00"
  },
  "pusher": {
    "id": 2,
    "username": "yangtao",
    "login": "yangtao",
    "full_name": "yangtao",
    "email": "yangtao@finogeeks.com",
    "avatar_url": "https://git.finogeeks.club/avatars/2"
  },
  "sender": {
    "id": 2,
    "username": "yangtao",
    "login": "yangtao",
    "full_name": "yangtao",
    "email": "yangtao@finogeeks.com",
    "avatar_url": "https://git.finogeeks.club/avatars/2"
  }
}'
echo "trigger success."