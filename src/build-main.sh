#!/bin/bash

IFS="
"

while read line; do
    if echo "$line" | grep -e '#PARSER-OPTION' >/dev/null; then
        perl src/build-parser.pl --option < src/list.txt
    elif echo "$line" | grep -e '#PARSER-COMMAND' >/dev/null; then
        perl src/build-parser.pl --command < src/list.txt
    elif echo "$line" | grep -e '#PARSER-LOAD' >/dev/null; then
        perl src/build-parser.pl --load < src/list.txt
    else
        echo "$line"
    fi
done

