#!/bin/bash

cat Property_Tax_Roll.csv \
| grep "MADISON SCHOOLS" \
| cut -d, -f7 \
| {
    sum=0
    n=0
    while read -r x; do
      [[ "$x" =~ ^[0-9]+(\.[0-9]+)?$ ]] || continue
      sum=$(awk -v s="$sum" -v v="$x" 'BEGIN{print s+v}')
      n=$((n+1))
    done
    awk -v s="$sum" -v n="$n" 'BEGIN{ if(n==0) print 0; else print s/n }'
  }
