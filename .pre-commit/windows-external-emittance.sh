#!/usr/bin/env bash

failed=0
for file in "$@"; do
    case "$file" in
        */windows/*) ;;
        *) continue ;;
    esac

    if ! jq --sort-keys 'walk(if type == "object" and has("flags") then
        .flags |= (split("|") | map(select(. != "NoExternalEmittance")) | join("|"))
    else . end)
    | [.[] | .lights = [.lights[] | .data.externalEmittance = "FXLightRegionSunlight"]]' \
        "$file" > "$file.tmp" 2>/dev/null; then
        echo "error: $file is not valid JSON"
        rm -f "$file.tmp"
        failed=1
        continue
    fi

    if ! diff -q "$file" "$file.tmp" &>/dev/null; then
        mv "$file.tmp" "$file"
        echo "fixed: $file (externalEmittance)"
        failed=1
    else
        rm -f "$file.tmp"
    fi
done

exit $failed
