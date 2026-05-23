#!/usr/bin/env bash
set -euo pipefail

# Usage: ec2-start-nonrunning.sh /path/to/instance_ids.txt
IDS_FILE="${1:-}"

if [[ -z "$IDS_FILE" || ! -f "$IDS_FILE" ]]; then
  echo "ERROR: Provide a valid instance IDs file path. Example: $0 ~/instance_ids.txt"
  exit 1
fi

# Optional: set region explicitly (recommended in cron)
# export AWS_REGION="ap-south-1"

TS="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[$TS] Starting check..."

# Read IDs, ignore empty lines and comments
mapfile -t IDS < <(grep -Eo '^i-[0-9a-f]+' "$IDS_FILE" | sort -u)

if [[ ${#IDS[@]} -eq 0 ]]; then
  echo "[$TS] No instance IDs found in $IDS_FILE"
  exit 0
fi

# Query current state for all IDs at once
aws ec2 describe-instances \
  --instance-ids "${IDS[@]}" \
  --query 'Reservations[].Instances[].{Id:InstanceId,State:State.Name}' \
  --output text |
while read -r ID STATE; do
  case "$STATE" in
    running)
      echo "[$TS] $ID is running (skip)"
      ;;
    pending)
      echo "[$TS] $ID is pending (already starting, skip)"
      ;;
    stopped)
      echo "[$TS] $ID is stopped -> start"
      aws ec2 start-instances --instance-ids "$ID" --output text || true
      ;;
    stopping|shutting-down|terminated)
      echo "[$TS] $ID is $STATE (skip)"
      ;;
    *)
      echo "[$TS] $ID is $STATE (unknown state, skip)"
      ;;
  esac
done

echo "[$TS] Done."