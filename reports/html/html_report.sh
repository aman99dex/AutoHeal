html_report() {
    REPORT="reports/html/system_report.html"

    mkdir -p reports/html

    cat > $REPORT <<EOF
<html>
<head><title>AutoHeal+ System Report</title></head>
<body>
<h1>System Report - $(date)</h1>
<p>CPU Usage: $CPU%</p>
<p>Memory Usage: $MEM%</p>
<p>Disk Usage: $DISK%</p>
<p>Services Checked: ${SERVICES[*]}</p>
</body>
</html>
EOF

    log "[REPORT] HTML system report generated."
}
#!/bin/bash