#!/bin/bash

pushd "$(dirname "$0")" >/dev/null
. util.sh

log_info "Preparing folder layout"
if [ ! -d work ]; then
    mkdir work
fi
if [ ! -d cache ]; then
    mkdir cache
fi
newcleandir temp

log_info "Initializing submodules"
git init
git submodule update --init

log_info "Resetting upstream repositories"
pushd base/Bukkit >/dev/null
git branch -f upstream
popd >/dev/null
pushd base/CraftBukkit >/dev/null
git branch -f upstream
popd >/dev/null

popd >/dev/null
log_info "Done. Now you should run ./remap-nms.sh to proceed."

