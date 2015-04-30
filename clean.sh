#!/bin/bash

. util.sh

function clean {
    if [ -d "$1" ]; then
        log_info "Removing directory $1"
        if ! rm -rf "$1"; then
            log_error "Unable to remove $1 directory"
            return 1
        fi
    fi
    return 0
}

log_info "Cleaning work directories"
pushd "$(dirname "$0")" >/dev/null

clean temp
FAILED=$?

clean build
FAILED=$(($FAILED+$?))

clean work
FAILED=$(($FAILED+$?))

popd >/dev/null
log_info "Done"
exit $FAILED

