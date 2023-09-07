#!/bin/bash

# script to ID the longest slimulation

ticks=( $(tail -n 1 out/*.log |  grep "," | awk -F "," '{ print $1 }'))
IFS=$'\n'

echo "${ticks[*]}" | sort -nr | head -n1
