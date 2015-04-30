#!/bin/bash

pushd "$(dirname "$0")" >/dev/null
. util.sh

function deploy {
    target=build/$1

    log_info "$1 deploying..."
    pushd $target >/dev/null

    if !(MAVEN_OPTS="$MAVEN_OPTS -Xmx1G" mvn deploy); then
        log_error "$1 failed to deploy"
        popd >/dev/null
        popd >/dev/null
        exit 1
    else
        log_info "$1 deployed"
    fi

    popd >/dev/null
}

deploy Bukkit
deploy CraftBukkit

popd >/dev/null
