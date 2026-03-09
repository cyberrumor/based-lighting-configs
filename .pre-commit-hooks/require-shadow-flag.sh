#!/usr/bin/env bash

failed=0
for file in "$@"; do
    case "$file" in
        */shadows/*) ;;
        *) continue ;;
    esac

    missing=$(jq -r '.. | objects | select(has("flags")) | .flags' "$file" 2>/dev/null \
        | grep -cv '\bShadow\b')

    if [ "$missing" -gt 0 ]; then
        echo "error: $file is missing Shadow flag in a shadows directory"
        failed=1
    fi
done

exit $failed
