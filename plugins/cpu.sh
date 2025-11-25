#!/bin/bash

cpu_check() {
    CPU=$(top -bn1 | awk '/Cpu/ {print 100 - $8}')
    CPU_INT=${CPU%.*}

    log "[CPU] Usage: $CPU%"

    if [ "$CPU_INT" -ge "$CPU_THRESHOLD" ]; then
        log "⚠️ [CPU] Threshold exceeded!"
        send_alert "CPU usage is above $CPU_THRESHOLD%. Current: $CPU%"
    fi
}
