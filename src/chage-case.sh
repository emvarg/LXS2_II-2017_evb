#!/bin/bash


for FILE in `find $1`
do
	NEWFILE=`echo $FILE | tr '[A-Z]' '[a-z]'`
	mv $FILE $NEWFILE
done
