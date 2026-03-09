#!/usr/bin/env bash

schema_url="https://raw.githubusercontent.com/dh-nunes/fomod-schema/master/ModuleConfig.xsd"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

if ! curl -sf "$schema_url" -o "$tmpdir/ModuleConfig.xsd"; then
    echo "error: failed to download FOMOD schema"
    exit 1
fi

# Fix upstream bug: leading space in type=" xs:string"
sed -i 's/type=" xs:string"/type="xs:string"/g' "$tmpdir/ModuleConfig.xsd"

failed=0
for file in "$@"; do
    if ! xmllint --noout --schema "$tmpdir/ModuleConfig.xsd" "$file" 2>&1; then
        failed=1
    fi
done

exit $failed
