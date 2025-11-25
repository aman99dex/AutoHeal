#!/bin/bash

source config.cfg
mkdir -p logs
LOGFILE="logs/$(date +%Y-%m-%d).log"

log() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOGFILE"
}

send_alert() {
    if [ "$ENABLE_TELEGRAM" = true ]; then
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
            -d chat_id="$TELEGRAM_CHAT_ID" \
            -d text="⚠️ AUTOHEAL+ ALERT: $1"
    fi
}


# Load plugins
for plugin in plugins/*.sh; do
    source "$plugin"
done

log "===== AutoHeal+ Monitoring Started ====="

cpu_check
mem_check
disk_check
service_check

if [ "$ENABLE_HTML_REPORT" = true ]; then
    html_report
fi

log "===== AutoHeal+ Monitoring Completed ====="
