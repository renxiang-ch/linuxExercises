#!/bin/bash

usage() {
  echo "usage: $0 <column> [file.csv]" 1>&2
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

col="$1"

if ! [[ "$col" =~ ^[1-9][0-9]*$ ]]; then
  usage
  exit 1
fi

file="/dev/stdin"
if [[ $# -eq 2 ]]; then
  file="$2"
  if [[ ! -f "$file" ]]; then
    echo "error: file not found: $file" 1>&2
    exit 1
  fi
fi

cut -d',' -f"$col" "$file" | tail -n +2 | {
  sum=0
  count=0

  while read -r x; do
    # skip empty lines/cells
    if [[ -z "$x" ]]; then
      continue
    fi
    sum=$(echo "$sum + $x" | bc)
    count=$((count + 1))
  done

  if [[ $count -eq 0 ]]; then
    echo "error: no data in column $col" 1>&2
    exit 1
  fi

  echo "scale=10; $sum / $count" | bc
}
