#!/usr/bin/env bash

failed=0
for file in "$@"; do
    if ! jq --sort-keys 'walk(if type == "object" then
        (if has("flags") then
            .flags |= (split("|") | if any(. == "NoExternalEmittance") then . else . + ["NoExternalEmittance"] end | join("|"))
        else . end)
        | if has("externalEmittance") then del(.externalEmittance) else . end
    else . end)' \
        "$file" > "$file.tmp" 2>/dev/null; then
        echo "error: $file is not valid JSON"
        rm -f "$file.tmp"
        failed=1
        continue
    fi

    if ! diff -q "$file" "$file.tmp" &>/dev/null; then
        mv "$file.tmp" "$file"
        echo "fixed: $file (NoExternalEmittance)"
        failed=1
    else
        rm -f "$file.tmp"
    fi
done

exit $failed
