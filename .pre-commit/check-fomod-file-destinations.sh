#!/usr/bin/env bash

# This script validates that filenames in <file source=""/> are the same as the
# filename in the associated dest="" clause. Directories don't need this, just
# files do.
failed=0
for file in "$@"; do
    # xmllint --xpath evaluates an XPath expression against the XML file.
    # '//*[self::file]' selects all elements named "file" anywhere in the
    # document (ignoring "folder" elements). xmllint dumps matching nodes
    # as a concatenated string, so we pipe through grep to split them.
    # '<file [^/]*/>' matches individual self-closing <file .../> tags.
    while IFS= read -r line; do
        source_path=$(echo "$line" | grep -oP 'source="[^"]*"' | sed 's/source="//;s/"$//')
        dest_path=$(echo "$line" | grep -oP 'destination="[^"]*"' | sed 's/destination="//;s/"$//')

        # ${var//\\//} replaces all backslashes with forward slashes so
        # Windows-style paths like "configs\bos\file.ini" become
        # "configs/bos/file.ini", allowing a single basename extraction.
        source_name="${source_path//\\//}"
        dest_name="${dest_path//\\//}"

        # ${var##*/} strips everything up to and including the last slash,
        # leaving just the filename (equivalent to basename).
        source_name="${source_name##*/}"
        dest_name="${dest_name##*/}"

        if [ "$source_name" != "$dest_name" ]; then
            echo "error: $file: file source '$source_path' has filename '$source_name' but destination '$dest_path' has filename '$dest_name'"
            failed=1
        fi
    done < <(xmllint --xpath '//*[self::file]' "$file" 2>/dev/null \
        | grep -oP '<file [^/]*/>' )
done

exit $failed
