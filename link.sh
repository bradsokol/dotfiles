#! /bin/bash

for filename in .*; do
	if [ "$filename" == "." ] || [ "$filename" == ".." ]; then
		continue
	fi
	ln -s `pwd`/"$filename" "$HOME"/"$filename"
done
