#!/bin/bash

pushd "$(dirname "$0")"

if [ ! -d .git ]; then
    echo "Git repository not found. Initializing..."
    git init
fi

git submodule update --init

cd shellbuilder
./prepare-build.sh
cd ..

git clone shellbuilder/build base/CraftBukkit

popd

