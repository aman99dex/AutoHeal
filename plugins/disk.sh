disk_check() {
    DISK=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    log "[DISK] Usage: $DISK%"

    if [ "$DISK" -ge "$DISK_THRESHOLD" ]; then
        log "🛑 [DISK] Disk critical!"
        send_alert "Disk usage crossed threshold: $DISK%"
    fi
}
#!/bin/bash