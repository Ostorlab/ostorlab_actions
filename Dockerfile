FROM python:3.8-slim-buster as base
RUN pip install -U ostorlab
CMD ostorlab --api-key="$INPUT_OSTORLAB_API_KEY"  ci-scan  run --title="$INPUT_SCAN_TITLE" --plan="$INPUT_PLAN" --log-favor=github --break_on_risk_rating="$INPUT_BREAK_ON_RISK_RATING" --max_wait_minutes="$INPUT_MAX_WAIT_MINUTES" $INPUT_ASSET_TYPE $INPUT_TARGET
