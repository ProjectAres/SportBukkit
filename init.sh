#!/bin/bash

ORIG_PWD="$(pwd)"
cd "$(dirname "$0")"

rm -Rf base build &> /dev/null
git submodule update --init

cd "$ORIG_PWD"
