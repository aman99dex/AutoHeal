service_check() {
    for svc in "${SERVICES[@]}"; do
        if systemctl is-active --quiet $svc; then
            log "[SERVICE] $svc is RUNNING"
        else
            log "[SERVICE] $svc is DOWN!"
            systemctl restart "$svc"
            sleep 2
            if systemctl is-active --quiet $svc; then
                log "[AUTOHEAL] Restarted $svc ✔"
                send_alert "$svc was DOWN and has been restarted."
            else
                log "[AUTOHEAL] Failed to restart $svc ❌"
                send_alert "$svc is DOWN and restart attempt FAILED!"
            fi
        fi
    done
}
#!/bin/bash