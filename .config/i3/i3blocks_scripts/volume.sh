#!/bin/bash

v10="$(pacmd list-sinks | grep 'volume' | tr -d ' ' | tr -d '\t' | tr -d '\n' | cut -d/ -f10)"
if [ "${v10}" == "" ]
then
	pacmd list-sinks | grep "volume" | tr -d ' ' | tr -d '\t' | tr -d '\n' | cut -d/ -f2
else
	echo "${v10}"
fi


