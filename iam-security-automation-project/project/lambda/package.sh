#!/usr/bin/env bash
# Helper script to package the Lambda function for deployment.
# Produces ../iam_detector.zip containing the handler and any dependencies.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_ZIP="${SCRIPT_DIR}/../iam_detector.zip"
TMP_DIR="${SCRIPT_DIR}/package_tmp"

echo "Packaging lambda from ${SCRIPT_DIR} to ${OUTPUT_ZIP}"

# Clean up
rm -rf "${TMP_DIR}" "${OUTPUT_ZIP}"
mkdir -p "${TMP_DIR}"

# Install dependencies into temp directory (if requirements.txt exists)
if [ -f "${SCRIPT_DIR}/requirements.txt" ]; then
  echo "Installing dependencies into ${TMP_DIR}"
  python3 -m pip install -r "${SCRIPT_DIR}/requirements.txt" -t "${TMP_DIR}"
fi

# Copy lambda source
cp "${SCRIPT_DIR}/iam_detector.py" "${TMP_DIR}/"

# Create zip
pushd "${TMP_DIR}" >/dev/null
zip -r "${OUTPUT_ZIP}" . >/dev/null
popd >/dev/null

# Clean up
rm -rf "${TMP_DIR}"

echo "Created ${OUTPUT_ZIP}"
