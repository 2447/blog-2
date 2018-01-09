#!/usr/bin/env bash

source $(dirname "$0")/_pre.sh

rm -rf $PREFIX/dist/-S
rm -rf $PREFIX/dist/-
rm -rf $PREFIX/src/-/md/\!/trash
rm -rf $PREFIX/src/-/S
rm -rf $PREFIX/src/-/md/\!/draft

rm $PREFIX/node_modules/8gua-blog.manifest.json

cd $PREFIX/src/cli
./dll.sh dlldist

cd $PREFIX/dist

cd $PREFIX/src
npm run dist
cp -R $PREFIX/src/- $PREFIX/dist/-

rm $PREFIX/node_modules/8gua-blog.manifest.json
