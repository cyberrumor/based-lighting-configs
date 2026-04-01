#!/usr/bin/env bash

failed=0
for file in "$@"; do
    case "$file" in
        */windows/*) ;;
        *) continue ;;
    esac

    helios_file="${file/windows\//windows_helios/}"
    helios_dir="$(dirname "$helios_file")"
    mkdir -p "$helios_dir"

    if ! jq --sort-keys 'walk(if type == "object" and has("externalEmittance") then
        .externalEmittance = "Helios_WeatherFx"
    else . end)' "$file" > "$helios_file.tmp" 2>/dev/null; then
        echo "error: $file is not valid JSON"
        rm -f "$helios_file.tmp"
        failed=1
        continue
    fi

    if ! diff -q "$helios_file" "$helios_file.tmp" &>/dev/null; then
        mv "$helios_file.tmp" "$helios_file"
        echo "synced: $file -> $helios_file"
        failed=1
    else
        rm -f "$helios_file.tmp"
    fi
done

exit $failed
