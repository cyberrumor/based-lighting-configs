#!/usr/bin/env bash

failed=0
for file in "$@"; do
    while IFS= read -r source; do
        # Convert backslashes to forward slashes for local path check
        local_path="${source//\\//}"
        if [ ! -e "$local_path" ]; then
            echo "error: $file references missing source: $source"
            failed=1
        fi
    done < <(xmllint --xpath '//*[self::file or self::folder]/@source' "$file" 2>/dev/null \
        | grep -oP 'source="[^"]*"' | sed 's/source="//;s/"$//')
done

exit $failed
