#!/bin/bash
# Submits the LM Studio sbatch job, shows live progress while waiting,
# then prints the SSH tunnel command to run from your local machine.

JOB_SCRIPT="job.slurm"
LOGIN_NODE="c2-login-001.ris.wustl.edu"
LOCAL_PORT=1234
REMOTE_PORT=1234
READY_PATTERN="Model loaded successfully"
POLL_INTERVAL=5
MAX_WAIT=600   # seconds to wait for server readiness before giving up

echo "Submitting ${JOB_SCRIPT}..."
SUBMIT_OUTPUT=$(sbatch "$JOB_SCRIPT")
echo "$SUBMIT_OUTPUT"

JOB_ID=$(echo "$SUBMIT_OUTPUT" | grep -oE '[0-9]+')
if [ -z "$JOB_ID" ]; then
  echo "Could not parse job ID from sbatch output. Exiting."
  exit 1
fi

LOG_FILE="lmstudio_${JOB_ID}.log"
echo "Job ID: ${JOB_ID}"
echo "Log file: ${LOG_FILE}"
echo ""

# --- Phase 1: wait for job to leave PENDING ---
echo "Waiting for job to be scheduled..."
NODE=""
last_state=""
while [ -z "$NODE" ]; do
  STATE=$(squeue -j "$JOB_ID" -h -o '%T' 2>/dev/null)
  if [ -z "$STATE" ]; then
    echo "Job ${JOB_ID} is no longer in the queue — it may have failed. Check ${LOG_FILE}."
    exit 1
  fi
  if [ "$STATE" == "RUNNING" ]; then
    NODE=$(squeue -j "$JOB_ID" -h -o '%N' | tr -d '[:space:]')
  else
    if [ "$STATE" != "$last_state" ]; then
      echo "  [$(date +%H:%M:%S)] job state: ${STATE}"
      last_state="$STATE"
    fi
    sleep "$POLL_INTERVAL"
  fi
done

echo "  [$(date +%H:%M:%S)] job is running on node: ${NODE}"
echo ""

# --- Phase 2: wait for log file to appear ---
echo "Waiting for log file to appear..."
elapsed=0
while [ ! -f "$LOG_FILE" ]; do
  if [ "$elapsed" -ge 60 ]; then
    echo "Log file never appeared after 60s. Something may be wrong — check squeue/sacct."
    exit 1
  fi
  sleep 2
  elapsed=$((elapsed + 2))
done

# --- Phase 3: stream log progress until ready ---
echo "Watching ${LOG_FILE} for startup progress..."
echo "--------------------------------------------------"

elapsed=0
last_line_count=0
while true; do
  if grep -q "$READY_PATTERN" "$LOG_FILE" 2>/dev/null; then
    echo "--------------------------------------------------"
    echo "Server is ready! ($(date +%H:%M:%S))"
    break
  fi

  # Print any new lines since last check
  current_line_count=$(wc -l < "$LOG_FILE" 2>/dev/null || echo 0)
  if [ "$current_line_count" -gt "$last_line_count" ]; then
    tail -n +$((last_line_count + 1)) "$LOG_FILE" | sed 's/^/  | /'
    last_line_count=$current_line_count
  fi

  if [ "$elapsed" -ge "$MAX_WAIT" ]; then
    echo "--------------------------------------------------"
    echo "Timed out after ${MAX_WAIT}s waiting for server readiness."
    echo "Check ${LOG_FILE} manually — it may still be downloading the model."
    exit 1
  fi

  sleep "$POLL_INTERVAL"
  elapsed=$((elapsed + POLL_INTERVAL))
done

echo ""
echo "=================================================="
echo "Run this in a separate terminal on your local machine:"
echo ""
echo "  ssh -L ${LOCAL_PORT}:${NODE}:${REMOTE_PORT} ${USER}@${LOGIN_NODE}"
echo ""
echo "Then test with:"
echo "  curl http://localhost:${LOCAL_PORT}/v1/models"
echo "=================================================="
