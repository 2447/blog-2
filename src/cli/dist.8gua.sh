#!/usr/bin/env bash

source $(dirname "$0")/_pre.sh

cd $PREFIX/src/cli

./dist.sh


PAGE=$PREFIX/../8gua.blog

cd $PAGE

rm -rf ./-S ./-

cp -R $PREFIX/dist/* $PAGE
mkdir -p $PAGE/-S/font
cp -R $PREFIX/file/font/.font-spider $PAGE/-S/font

cd $PAGE
rm -rf index.html
mv ./-S/index.html .
rm -rf 404.html
cp index.html 404.html
#ln -s ./-S/index.html .
#ln -s index.html 404.html

git add .

sync() {
    git add -u && git commit -m '.' ;
    local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' |awk -F' ' '{print $2}'`
    git pull origin $branch && git push origin $branch;
}

sync
git push github &
git push bitbucket &

