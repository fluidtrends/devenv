#!/bin/bash

HERE=`pwd`
ROOT=`dirname $HERE`
MODS=(
    "binda"
    "rara"
    "papanache"
    "cassi" 
    "dodi" 
    "carmel/sdk:@carmel/sdk"
    "chunky/carmel:chunky-carmel-plugin"
    "chunky/cli:chunky-cli"
)

DEPS=(
 "rara:binda"
 "dodi:rara"
 "dodi:cassi"
 "carmel/sdk:dodi"
 "chunky/carmel:@carmel/sdk"
 "chunky/cli:chunky-carmel-plugin"
)

NPM_CMD=`which npm`
NPM_BIN=`dirname $NPM_CMD`
NPM_ROOT=`dirname $NPM_BIN`
NPM_MODS="$NPM_ROOT/lib/node_modules"

echo "[dev] setting up ... "

for mod in "${MODS[@]}"
do
    dir=`echo $mod | cut -d ":" -f 1`
    id=`echo $mod | cut -d ":" -f 2`

    if [[ ! -d "$ROOT/$dir" ]]; then
        continue
    fi

    if [ -L "$NPM_MODS/${id}" ] ; then
        continue
    fi

    echo
    echo "*** Linking $id ***"
    cd "$ROOT/$dir"
    npm link

    if [ -L "$NPM_MODS/${id}" ] ; then
        echo "*** [OK] ***"
    else 
        echo "*** [FAIL] ***"
    fi
done

for dep in "${DEPS[@]}"
do
    dir=`echo $dep | cut -d ":" -f 1`
    targ=`echo $dep | cut -d ":" -f 2`

    if [[ ! -d "$ROOT/$dir" ]]; then
        continue
    fi

    if [ -L "$ROOT/$dir/node_modules/${targ}" ] ; then
        continue
    fi

    echo
    echo "*** Linking $targ into $dir ***"
    cd "$ROOT/$dir"
    npm link $targ

    if [ -L "$ROOT/$dir/node_modules/${targ}" ] ; then
        echo "*** [OK] ***"
    else 
        echo "*** [FAIL] ***"
    fi
done

echo "[dev] done. "



