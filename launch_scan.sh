#!/bin/bash
set -e
ostorlab ci-scan run --api-key="$INPUT_OSTORLAB_API_KEY" --title="$INPUT_SCAN_TITLE" --plan="$INPUT_PLAN" --type="$INPUT_TYPE" --file "$INPUT_FILE" --log_favor=github
