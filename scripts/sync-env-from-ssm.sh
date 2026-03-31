#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Uso: $0 <dev|prod> [output_file]"
  exit 1
fi

ENVIRONMENT="$1"
OUTPUT_FILE="${2:-.env}"

if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "prod" ]; then
  echo "Ambiente invalido: $ENVIRONMENT (use dev ou prod)"
  exit 1
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "aws cli nao encontrado na maquina"
  exit 1
fi

BASE_PATH="/piaca/${ENVIRONMENT}/db"

fetch_param() {
  local name="$1"
  aws ssm get-parameter \
    --name "${BASE_PATH}/${name}" \
    --with-decryption \
    --query 'Parameter.Value' \
    --output text
}

DB_HOST="$(fetch_param host)"
DB_PORT="$(fetch_param port)"
DB_NAME="$(fetch_param name)"
DB_USER="$(fetch_param user)"
DB_PASSWORD="$(fetch_param password)"

cat > "$OUTPUT_FILE" <<EOF
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
EOF

echo "Arquivo de ambiente atualizado em ${OUTPUT_FILE} usando parametros ${BASE_PATH}/*"
