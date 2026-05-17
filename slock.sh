#!/bin/bash
set -euo pipefail

slock

# After unlock, send key combos
xdotool key super+b
xdotool key super+Escape
