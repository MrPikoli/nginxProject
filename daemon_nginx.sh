#!/bin/bash

ACCESS_LOG="/var/log/nginx/access.log"
ERROR_LOG="/var/log/nginx/error.log"
OUTPUT_LOG="/var/log/f1.log"
CLEAR_LOG="/var/log/f2.log"
400_log="/var/log/f3.log"
500_log="/var/log/f4.log"
TEMP="/var/log/ftemp.log"


position=0
MAX_SIZE=300000

# Цикл демона
while true; do

TOTAL_LINES_AC=$(wc -l < "$ACCESS_LOG")
TOTAL_LINES_ERR=$(wc -l < "$ERROR_LOG")
CURRENT_SIZE=$(stat -c %s "$OUTPUT_LOG")

> "$TEMP"

if (( TOTAL_LINES_AC > LAST_LINE_AC )); then
        NEW_LINES_AC=$(( TOTAL_LINES_AC - LAST_LINE_AC ))
        tail -n "$NEW_LINES_AC" "$ACCESS_LOG" >> "$TEMP"
        LAST_LINE_AC=$TOTAL_LINES_AC

    fi


if (( TOTAL_LINES_ERR > LAST_LINE_ERR )); then
        NEW_LINES_ERR=$(( TOTAL_LINES_ERR - LAST_LINE_ERR ))
        tail -n "$NEW_LINES_ERR" "$ERROR_LOG" >> "$TEMP"
        LAST_LINE_ERR=$TOTAL_LINES_ERR

    fi


cat "$TEMP" >> "$OUTPUT_LOG"

awk '$9 ~ /^4[0-9][0-9]$/' "$TEMP" >> /var/log/f3.log
awk '$9 ~ /^5[0-9][0-9]$/' "$TEMP" >> /var/log/f3.log


    if (( CURRENT_SIZE >= MAX_SIZE )); then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$TIMESTAMP: OUTPUT_LOG is clear" >> "$CLEAR_LOG"
	echo > "$OUTPUT_LOG"
        LAST_LINE_AC=$TOTAL_LINES_AC
	LAST_LINE_ERR=$TOTAL_LINES_ERR
 fi



    sleep 5
done
