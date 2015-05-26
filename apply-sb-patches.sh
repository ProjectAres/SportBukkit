#!/bin/bash

pushd "$(dirname "$0")" >/dev/null
. util.sh

function requireCleanWorkTree {
    # Update the index
    git update-index -q --ignore-submodules --refresh
    err=0

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
        log_error "cannot apply patches to $1: you have unstaged changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        log_error "cannot apply patches to $1: your index contains uncommitted changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if [ $err = 1 ]
    then
        log_error "Please commit or stash them."
        exit 1
    fi
}

function applyPatches {
    base=$1
    what=$base/$2
    target=build/$2
    patches=$2

    pushd $what >/dev/null
    git branch -f upstream >/dev/null
    popd >/dev/null
    if [ ! -d $target ]; then
        git clone $what $target
    fi

    pushd $target >/dev/null

    requireCleanWorkTree $target

    log_info "Resetting $target to $what..."
    git remote rm upstream 2>/dev/null 2>&1
    git remote add upstream ../../$what >/dev/null 2>&1
    git fetch upstream >/dev/null 2>&1
    git reset --hard upstream/upstream

    log_info "Applying patches to $target..."
    git am --abort

    if !(git am --3way ../../$patches/*.patch); then
        log_error "Something did not apply cleanly to $target."
        log_error "Please review above details and finish the apply then"
        log_error "save the changes with rebuildPatches.sh"
        popd >/dev/null
        popd >/dev/null
        exit 1
    else
        log_info "  Patches applied cleanly to $target"
    fi

    cd ../..
}

log_info "Applying SportBukkit patches"

applyPatches base Bukkit
applyPatches work CraftBukkit

popd >/dev/null
log_info "Done. Now you should run ./compile.sh to proceed."

