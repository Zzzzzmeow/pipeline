#!/bin/bash
set -e

CANGJIE_HOME="${CANGJIE_HOME:-/opt/cangjie}"
export PATH="${CANGJIE_HOME}/bin:${CANGJIE_HOME}/tools/bin:${PATH}"

echo "=== Cangjie Environment ==="
cjc --version
cjpm --version

echo ""
echo "=== Build ==="
cjpm build

echo ""
echo "=== Unit Test ==="
cjpm test --verbose

echo ""
echo "=== CI/CD Pipeline Completed ==="
