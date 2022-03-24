FROM python:3.8-slim-buster as base
FROM base as builder
RUN mkdir /install
WORKDIR /install
RUN pip install --prefix=/install ostorlab
FROM base
WORKDIR /root/
COPY --from=builder /install /usr/local
CMD ostorlab --api-key="$INPUT_OSTORLAB_API_KEY"  ci-scan  run --log-flavor=github --title="$INPUT_SCAN_TITLE" --scan-profile="$INPUT_SCAN_PROFILE"  --break-on-risk-rating="$INPUT_BREAK_ON_RISK_RATING" --max-wait-minutes="$INPUT_MAX_WAIT_MINUTES" $INPUT_ASSET_TYPE $INPUT_TARGET
