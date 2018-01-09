#!/usr/bin/env bash

PREFIX=$(cd "$(dirname "$0")"; pwd)/../..


export NODE_PATH=$PREFIX/node_modules:$NODE_PATH

ROOT=$PREFIX/dist/-S/dll
mkdir -p $ROOT

cd $ROOT
rm -rf *.js *.css

cd $PREFIX/src
npm run $1

# 防止编译的时候页面出错
# rsync -a dist $PREFIX/data/web/

