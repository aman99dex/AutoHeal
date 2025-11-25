mem_check() {
    MEM=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
    log "[MEMORY] Usage: $MEM%"

    if [ "$MEM" -ge "$MEM_THRESHOLD" ]; then
        log "🚨 [MEMORY] Threshold exceeded!"
        send_alert "Memory usage crossed limit: $MEM%"
    fi
}
#!/bin/bash