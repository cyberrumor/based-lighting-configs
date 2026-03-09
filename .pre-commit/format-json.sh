#!/usr/bin/env bash

failed=0
for file in "$@"; do
    if ! jq --sort-keys . "$file" > "$file.tmp" 2>/dev/null; then
        echo "error: $file is not valid JSON"
        rm -f "$file.tmp"
        failed=1
        continue
    fi
    if ! diff -q "$file" "$file.tmp" &>/dev/null; then
        mv "$file.tmp" "$file"
        echo "formatted: $file"
        failed=1
    else
        rm -f "$file.tmp"
    fi
done

exit $failed
