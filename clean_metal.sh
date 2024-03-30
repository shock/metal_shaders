#!/bin/bash

# Get the directory containing the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR

# Check if the current directory is the same as the script directory
if [ "$(pwd)" = "$DIR" ]; then
    rm -rf *.metallib
    rm -rf *.metallibsym
    rm -rf *.air
else
    echo "can't cd to `$DIR`"
fi
