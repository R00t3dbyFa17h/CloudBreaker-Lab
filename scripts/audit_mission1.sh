#!/bin/bash

# CloudBreaker Lab - Mission 1 Audit
# Usage: ./audit_mission1.sh <BUCKET_NAME>

BUCKET=$1

if [ -z "$BUCKET" ]; then
    echo "Usage: ./audit_mission1.sh <BUCKET_NAME>"
    exit 1
fi

echo "[*] Auditing Bucket: $BUCKET"
echo "[*] Attempting Anonymous Access (The Hack)..."

# Try to list files without credentials (--no-sign-request)
aws s3 ls s3://$BUCKET --no-sign-request > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "❌ CRITICAL VULNERABILITY FOUND!"
    echo "   The bucket '$BUCKET' is Publicly Accessible."
    echo "   Any anonymous user can read your data."
else
    echo "✅ SECURE."
    echo "   Access Denied for anonymous users."
fi
