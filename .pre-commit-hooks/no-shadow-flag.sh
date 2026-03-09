#!/usr/bin/env bash

failed=0
for file in "$@"; do
    case "$file" in
        */shadows/*) continue ;;
    esac

    matches=$(jq -r '.. | objects | select(has("flags")) | .flags' "$file" 2>/dev/null \
        | grep -c '\bShadow\b')

    if [ "$matches" -gt 0 ]; then
        echo "error: $file contains Shadow flag outside a shadows directory"
        failed=1
    fi
done

exit $failed
