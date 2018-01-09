#!/usr/bin/env bash

source $(dirname "$0")/_pre.sh

if [ ! -f $PREFIX/node_modules/8gua-blog.manifest.json ]; then
    $PREFIX/src/cli/dll.sh dlldev
fi

cd $PREFIX/src
node conf/dev.js
