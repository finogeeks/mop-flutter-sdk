#!/bin/bash

git tag |xargs git tag -d
git pull --tags
git tag -d $1
git push origin --delete tag $1
git add -u && git commit -m "add tag $1"
git tag -m "$message" $1
git push --follow-tags
