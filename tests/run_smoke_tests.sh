#!/bin/bash

if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "No arguments supplied"
    echo "Synopsis: run_smoke_test.sh <absolute-path-to-the-project>"
    exit 1
fi

PROJECT_ABSOLUTE_PATH=$1

"$PROJECT_ABSOLUTE_PATH/gradlew"
"$PROJECT_ABSOLUTE_PATH/gradlew" tasks
"$PROJECT_ABSOLUTE_PATH/gradlew" build
