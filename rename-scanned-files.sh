#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2012
# Using `find` would require to get rid of the leading './', which is not worth
# the effort. We simply can use `ls -1` instead.
read -r TITLE _ _ EXT < <(ls -1 | head -n 1 | tr '.-' ' ')

# Check that all file names are in the format
# Gemischte_Dokumente-(Front|Rück)-<number>.png
# shellcheck disable=SC2010
if ls -1 | grep -qvE "^${TITLE}-(Front|Rück)-[0-9]+\.${EXT}\$"; then
	echo "Error: Found files that do not match the expected format."
	exit 1
fi

# Check that there are as many Front as Rück
# local NOF_FRONT NOF_RUECK
NOF_FRONT=$(find . -iname "*-Front-*.png" -exec echo \; | wc -l)
NOF_RUECK=$(find . -iname "*-Rück-*.png" -exec echo \; | wc -l)
if [ "${NOF_FRONT}" -ne "${NOF_RUECK}" ]; then
	echo "Error: Found different number of Front and Rück files."
	exit 1
fi

# Check that all files are consecutivly numbered
WIDTH=${#NOF_FRONT}
seq "$NOF_FRONT" | xargs printf "%0${WIDTH}d\n" |
	while read -r num; do
		for side in Front Rück; do
			CURRENT_FILE="${TITLE}-${side}-${num}.png"
			if ! [[ -f "${CURRENT_FILE}" ]]; then
				echo "Error: Missing file ${CURRENT_FILE}."
				exit 1
			fi
		done
	done

# Rename files
for f in *Rück*; do
	read -r title suffix srcnum ext < <(echo "$f" | tr '.-' ' ')
	destnum=$((NOF_RUECK - 10#$srcnum + 1))
	mv "$f" "${title}-$(printf "%0${WIDTH}d" "$destnum")-${suffix}.${ext}"
done
rename 's/-Front-(\d+).png/-$1-Front.png/' ./*
