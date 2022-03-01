#!/bin/bash
set -e
ls
echo "----------------------"
echo staring scan with the following
echo api_key="$INPUT_OSTORLAB_API_KEY"
echo title="$INPUT_SCAN_TITLE"
echo plan="$INPUT_PLAN"
echo type="$INPUT_TYPE"
echo file="$INPUT_FILE"
ostorlab ci-scan run --api-key="$INPUT_OSTORLAB_API_KEY" --title="$INPUT_SCAN_TITLE" --plan="$INPUT_PLAN" --type="$INPUT_TYPE" --file "$INPUT_FILE"
