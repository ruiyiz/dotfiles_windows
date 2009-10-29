#!/bin/sh

# Passing the following parameters to mergetool:
#   local base remote merge_result
"C:/PortableApps/DiffMerge/DiffMerge.exe" "$1" "$2" "$3" --result="$4" --title1="Mine" --title2="Merging to: $4" --title3="Theirs"
