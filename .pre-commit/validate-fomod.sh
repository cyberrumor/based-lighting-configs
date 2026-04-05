#!/usr/bin/env bash

schema_url="https://raw.githubusercontent.com/Nexus-Mods/fomod-installer/master/src/InstallScripting/XmlScript/Schemas/XmlScript5.0.xsd"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

if ! curl -sf "$schema_url" -o "$tmpdir/XmlScript5.0.xsd"; then
    echo "error: failed to download FOMOD schema"
    exit 1
fi

# Fix upstream bug: leading space in type=" xs:string"
sed -i 's/type=" xs:string"/type="xs:string"/g' "$tmpdir/XmlScript5.0.xsd"

failed=0
for file in "$@"; do
    # Validate against XSD schema first
    if ! xmllint --noout --schema "$tmpdir/XmlScript5.0.xsd" "$file" 2>&1; then
        failed=1
        continue
    fi

    # Check source paths exist
    while IFS= read -r source; do
        local_path="${source//\\//}"
        if [ ! -e "$local_path" ]; then
            echo "error: $file references missing source: $source"
            failed=1
        fi
    done < <(xmllint --xpath '//*[self::file or self::folder]/@source' "$file" 2>/dev/null \
        | grep -oP 'source="[^"]*"' | sed 's/source="//;s/"$//')

    # Check file source and destination filenames match
    while IFS= read -r line; do
        source_path=$(echo "$line" | grep -oP 'source="[^"]*"' | sed 's/source="//;s/"$//')
        dest_path=$(echo "$line" | grep -oP 'destination="[^"]*"' | sed 's/destination="//;s/"$//')

        source_name="${source_path//\\//}"
        dest_name="${dest_path//\\//}"

        source_name="${source_name##*/}"
        dest_name="${dest_name##*/}"

        if [ "$source_name" != "$dest_name" ]; then
            echo "error: $file: file source '$source_path' has filename '$source_name' but destination '$dest_path' has filename '$dest_name'"
            failed=1
        fi
    done < <(xmllint --xpath '//*[self::file]' "$file" 2>/dev/null \
        | grep -oP '<file [^/]*/>')
done

exit $failed
