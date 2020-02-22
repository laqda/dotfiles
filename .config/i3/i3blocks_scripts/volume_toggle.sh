#!/bin/bash

if [[ $(pacmd list-sinks | grep "muted" | tr -d ' ' | tr -d '\t' | tr -d '\n' | cut -d: -f3) == *yes* ]]; then
	echo ""
else
	echo ""
fi

