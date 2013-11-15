#!/usr/bin/env bash
if [ -z "$1" ]
then
        echo "USAGE: wgetarx <tarball-url>"
else
        curl $1 | tar zxv
fi
