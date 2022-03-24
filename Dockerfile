FROM python:3.8-alpine
RUN pip install ostorlab
CMD ostorlab  --api-key="$INPUT_OSTORLAB_API_KEY"  ci-scan  run --log-flavor=github --title="$INPUT_SCAN_TITLE" --scan-profile="$INPUT_SCAN_PROFILE"  --break-on-risk-rating="$INPUT_BREAK_ON_RISK_RATING" --max-wait-minutes="$INPUT_MAX_WAIT_MINUTES" $INPUT_ASSET_TYPE $INPUT_TARGET
