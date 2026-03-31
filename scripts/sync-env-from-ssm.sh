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

resolve_region() {
  if [ -n "${AWS_REGION:-}" ]; then
    echo "${AWS_REGION}"
    return
  fi

  if [ -n "${AWS_DEFAULT_REGION:-}" ]; then
    echo "${AWS_DEFAULT_REGION}"
    return
  fi

  # Try IMDSv2 first, then IMDSv1 as fallback.
  local token
  token="$(curl -sS -m 2 -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60" || true)"

  if [ -n "$token" ]; then
    curl -sS -m 2 -H "X-aws-ec2-metadata-token: $token" "http://169.254.169.254/latest/dynamic/instance-identity/document" \
      | sed -n 's/.*"region"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
      | head -n 1
    return
  fi

  curl -sS -m 2 "http://169.254.169.254/latest/dynamic/instance-identity/document" \
    | sed -n 's/.*"region"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
    | head -n 1
}

AWS_REGION_RESOLVED="$(resolve_region)"

if [ -z "$AWS_REGION_RESOLVED" ]; then
  echo "Nao foi possivel resolver a regiao AWS. Defina AWS_REGION/AWS_DEFAULT_REGION na instancia."
  exit 1
fi

echo "Lendo parametros do SSM na regiao ${AWS_REGION_RESOLVED}"

fetch_param() {
  local name="$1"
  aws ssm get-parameter \
    --region "${AWS_REGION_RESOLVED}" \
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
