#!/bin/bash
#
# Source: https://grantwinney.com/5-things-you-can-do-with-a-locally-cloned-github-wiki/
FILES="*.md"
for f in $FILES
do
    base=`basename $f ".md"`
    pandoc -s -f markdown $f > "$base".html
done