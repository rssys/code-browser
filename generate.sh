#!/bin/bash

BREW_PREFIX=$(brew --prefix)

INDEX_DIRS="$@"

echo "${INDEX_DIRS}"

# Genetrate the tags file
${BREW_PREFIX}/bin/ctags -R ${INDEX_DIRS}

# Generate the INDEX.txt file
grep -n -R . ${INDEX_DIRS}  > INDEX.txt
