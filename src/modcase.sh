#!/bin/bash

# Este script cambia los archivos de mayusculas a
# minusculas.

for  FILE in $(find $1 -type f)
do
	NEWFILE=$(echo $FILE | tr '[A-Z]' '[a-z]')
	mv $FILE $NEWFILE
done
