#!/usr/bin/env bash

PREFIX=$(cd "$(dirname "$0")"; pwd)

cd $PREFIX
./src/cli/dist.8gua.sh
./dev
