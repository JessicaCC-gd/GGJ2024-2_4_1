#!/bin/sh
echo -ne '\033c\033]0;Mr. Grumpy\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Mr_Grumpy.x86_64" "$@"
