#!/usr/bin/env bash
find $(pwd)/lib -type f -name '*.class' -print -exec rm -f {} \;
