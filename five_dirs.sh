#!/bin/bash

mkdir -p five

for i in {1..5}; do
    mkdir -p five/dir$i
    for j in {1..4}; do
        file="five/dir$i/file$j"
        : > "$file"
        for k in $(seq 1 $j); do
            echo "$j" >> "$file"
        done
    done
done
