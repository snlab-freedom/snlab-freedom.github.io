#!/bin/bash

WORK_DIR=$(dirname $0)
cd $WORK_DIR
echo "Enter $WORK_DIR"

echo 'Check themes...'
if [ ! -d themes/hugo-theme-cooler ]; then
    echo 'themes/hugo-theme-cooler is not found'
    echo 'Clone themes/hugo-theme-cooler from github...'
    git clone https://github.com/snlab-freedom/hugo-theme-cooler themes/hugo-theme-cooler
    echo 'Done!'
fi

pushd themes/hugo-theme-cooler
if [ -z "$(git status --porcelain)" ]; then
    echo 'themes/hugo-theme-cooler is clean'
    echo 'Sync themes/hugo-theme-cooler from github...'
    git pull
    echo 'Done!'
fi
popd

echo 'Check public...'
if [ -d public ]; then
    echo 'public exists'
    pushd public;
    echo 'Check workspace status:'
    git status --porcelain
    if [ $? -eq 0 ]; then
        if [ -n "$(git status --porcelain)" ]; then
            echo 'Workspace is not clean'
            echo 'Cleanup the workspace'
            git clean -xdf
            git reset --hard origin/master
        fi
        echo 'Sync public from github...'
        git pull;
        popd;
    else
        echo 'There is no git repo :('
        popd
        rm -rf public
        git clone https://github.com/snlab-freedom/snlab-freedom.github.io -b master public
    fi
else
    echo 'There is no git repo :('
    rm -rf public
    git clone https://github.com/snlab-freedom/snlab-freedom.github.io -b master public
fi

hugo
