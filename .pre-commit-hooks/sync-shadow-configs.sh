#!/usr/bin/env bash

failed=0
for file in "$@"; do
    case "$file" in
        */no_shadows/*) ;;
        *) continue ;;
    esac

    shadow_file="${file/no_shadows/shadows}"
    shadow_dir="$(dirname "$shadow_file")"
    mkdir -p "$shadow_dir"

    if ! jq --sort-keys 'walk(if type == "object" and has("flags") then
        .flags |= (split("|") | if any(. == "Shadow") then . else . + ["Shadow"] end | sort | join("|"))
    else . end)' "$file" > "$shadow_file.tmp" 2>/dev/null; then
        echo "error: $file is not valid JSON"
        rm -f "$shadow_file.tmp"
        failed=1
        continue
    fi

    if ! diff -q "$shadow_file" "$shadow_file.tmp" &>/dev/null; then
        mv "$shadow_file.tmp" "$shadow_file"
        echo "synced: $file -> $shadow_file"
        failed=1
    else
        rm -f "$shadow_file.tmp"
    fi
done

exit $failed
