#!/usr/bin/env bash

failed=0

while IFS= read -r -d '' no_shadow_dir; do
    shadow_dir="${no_shadow_dir/no_shadows/shadows}"

    if [ ! -d "$shadow_dir" ]; then
        echo "error: missing shadows directory: $shadow_dir"
        failed=1
        continue
    fi

    for f in "$no_shadow_dir"/*.json; do
        [ -e "$f" ] || continue
        basename=$(basename "$f")
        if [ ! -f "$shadow_dir/$basename" ]; then
            echo "error: $shadow_dir/$basename missing (exists in no_shadows)"
            failed=1
        fi
    done

    for f in "$shadow_dir"/*.json; do
        [ -e "$f" ] || continue
        basename=$(basename "$f")
        if [ ! -f "$no_shadow_dir/$basename" ]; then
            echo "error: $no_shadow_dir/$basename missing (exists in shadows)"
            failed=1
        fi
    done
done < <(find . -type d -name no_shadows -print0)

exit $failed
