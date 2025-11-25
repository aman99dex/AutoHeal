# AutoHeal+

AutoHeal+ is a lightweight, shell-script-driven system health monitoring and auto-healing framework. It uses a plugin-based architecture to detect issues and optionally apply corrective actions. The framework is designed to be easily extended with custom plugins and integrates with logs and HTML reports for visibility.

## Features
- Plugin-based checks and healers (extensible)
- Simple configuration via [config.cfg](AutoHeal+/config.cfg)
- Logging into [logs/](AutoHeal+/logs/)
- Optional HTML reports in [reports/html/](AutoHeal+/reports/html/)
- Easy install/uninstall via [install.sh](AutoHeal+/install.sh) and [uninstall.sh](AutoHeal+/uninstall.sh)
- Main runner: [autoheal.sh](AutoHeal+/autoheal.sh)

## Requirements
- Linux / Unix-like system
- bash
- Optional: cron/systemd for scheduling
- Make sure plugin scripts are executable (chmod +x)

## Quick Start
1. Inspect and update configuration:
   - [AutoHeal+/config.cfg](AutoHeal+/config.cfg)

2. Install (sets up environment and required deps):
```bash
./AutoHeal+/install.sh
```

3. Run manually:
```bash
cd AutoHeal+
./autoheal.sh
```

4. Run in background / schedule:
- Launch as a background process:
```bash
nohup ./autoheal.sh &> autoheal.log &
```
- Or use cron/systemd to schedule as required.

5. Uninstall:
```bash
./AutoHeal+/uninstall.sh
```

## Plugin System
Plugins live in [AutoHeal+/plugins/](AutoHeal+/plugins/) (examples: [cpu.sh](AutoHeal+/plugins/cpu.sh)). Each plugin is a shell script that should follow the recommended interface:

- Interface contract:
  - `plugin.sh check`: must return `0` if OK and `>0` if problem or check error. Print a short message to stdout describing the issue for logs.
  - `plugin.sh heal`: optional; apply recovery steps and return `0` on successful recovery, non-zero on failure.
  - `plugin.sh status`: optional; provide status output to integrate into reports.

- Example usage by the runner (what [autoheal.sh](AutoHeal+/autoheal.sh) typically does):
  1. Runs `plugin check`. If status code != 0, logs it and optionally runs `plugin heal`.
  2. If heal succeeds, logs the success; otherwise logs the failure.

### Example Plugin Template
See [AutoHeal+/plugins/cpu.sh](AutoHeal+/plugins/cpu.sh) for a real example. Here is a simplified template:
```sh
#!/bin/bash

# Usage: plugin.sh check|heal|status

case "$1" in
  check)
    # Return 0 if everything OK, non-zero otherwise
    # Example: check if CPU usage > threshold
    cpu_usage=$(top -bn1 | awk '/Cpu/ {print $2+$4}') # simplified
    threshold=80
    awk -v usage="$cpu_usage" -v thr="$threshold" 'BEGIN { exit !(usage > thr) }'
    if (( $(echo "$cpu_usage > $threshold" | bc -l) )); then
      echo "CPU usage high: $cpu_usage%"
      exit 1
    fi
    echo "CPU usage OK: $cpu_usage%"
    exit 0
    ;;
  heal)
    # Attempt to mitigate: e.g., restart offending service or cleanup
    # Returns 0 on success, non-zero on failure
    # Example: kill a runaway process (careful!)
    echo "Attempting basic CPU mitigation..."
    # Implement real mitigation here
    exit 0
    ;;
  status)
    echo "CPU plugin: status report"
    exit 0
    ;;
  *)
    echo "Usage: $0 check|heal|status"
    exit 2
    ;;
esac
```

## Configuration
- [AutoHeal+/config.cfg](AutoHeal+/config.cfg) contains settings for:
  - plugin scheduling
  - thresholds and behavior (e.g., auto-heal enabled/disabled)
  - destination of logs & report settings

Open this file to tune AutoHeal+ to your environment.

## Logs and Reports
- Execution logs: [AutoHeal+/logs/](AutoHeal+/logs/) — the main runner and plugin output are recorded here.
- HTML reports: [AutoHeal+/reports/html/](AutoHeal+/reports/html/) — useful for web or offline review of past checks.

## Uninstall
- Run [AutoHeal+/uninstall.sh](AutoHeal+/uninstall.sh) to remove configs and cleanup runtime files.

## Development & Contributing
- Add plugins inside [AutoHeal+/plugins/](AutoHeal+/plugins/). Follow the plugin template above and ensure plugins are executable.
- Please provide clear messaging in plugins to improve logs and reporting.
- Testing: Run [AutoHeal+/autoheal.sh](AutoHeal+/autoheal.sh) manually to test plugin behavior; check [AutoHeal+/logs/](AutoHeal+/logs/) for output.

## Files of interest
- Runner: [AutoHeal+/autoheal.sh](AutoHeal+/autoheal.sh)
- Configuration: [AutoHeal+/config.cfg](AutoHeal+/config.cfg)
- Install: [AutoHeal+/install.sh](AutoHeal+/install.sh)
- Uninstall: [AutoHeal+/uninstall.sh](AutoHeal+/uninstall.sh)
- Plugins: [AutoHeal+/plugins/](AutoHeal+/plugins/)
- Example plugin: [AutoHeal+/plugins/cpu.sh](AutoHeal+/plugins/cpu.sh)
- Logs: [AutoHeal+/logs/](AutoHeal+/logs/)
- Reports: [AutoHeal+/reports/html/](AutoHeal+/reports/html/)


