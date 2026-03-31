#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <frontend|services> <branch> [app_dir] [compose_file] [environment]"
  exit 1
fi

STACK="$1"
BRANCH="$2"
APP_DIR="${3:-/home/ec2-user/app}"
COMPOSE_FILE="${4:-docker-compose.yml}"
ENVIRONMENT="${5:-}"

if [ "$STACK" != "frontend" ] && [ "$STACK" != "services" ]; then
  echo "Stack invalida: $STACK (use frontend ou services)"
  exit 1
fi

cd "$APP_DIR"

echo "[deploy] Atualizando codigo da branch $BRANCH"
git fetch origin
git checkout "$BRANCH"
git reset --hard "origin/$BRANCH"

if [ -n "$ENVIRONMENT" ] && [ -x "scripts/sync-env-from-ssm.sh" ]; then
  echo "[deploy] Sincronizando variaveis de ambiente do SSM para $ENVIRONMENT"
  scripts/sync-env-from-ssm.sh "$ENVIRONMENT" "$APP_DIR/.env"
fi

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Arquivo compose nao encontrado: $COMPOSE_FILE"
  exit 1
fi

mapfile -t ALL_SERVICES < <(docker-compose -f "$COMPOSE_FILE" config --services)

if [ "${#ALL_SERVICES[@]}" -eq 0 ]; then
  echo "Nenhum servico encontrado em $COMPOSE_FILE"
  exit 1
fi

FRONTEND_SERVICE=""
for service in "piaca-frontend" "frontend"; do
  if printf '%s\n' "${ALL_SERVICES[@]}" | grep -qx "$service"; then
    FRONTEND_SERVICE="$service"
    break
  fi
done

if [ "$STACK" = "frontend" ]; then
  if [ -z "$FRONTEND_SERVICE" ]; then
    echo "Nenhum servico de frontend (piaca-frontend/frontend) definido no compose. Deploy ignorado."
    exit 0
  fi

  echo "[deploy] Subindo frontend: $FRONTEND_SERVICE"
  docker-compose -f "$COMPOSE_FILE" up -d --build "$FRONTEND_SERVICE"
  exit 0
fi

DEPLOY_SERVICES=()
for service in "${ALL_SERVICES[@]}"; do
  if [ "$service" = "piaca-frontend" ] || [ "$service" = "frontend" ]; then
    continue
  fi
  DEPLOY_SERVICES+=("$service")
done

if [ "${#DEPLOY_SERVICES[@]}" -eq 0 ]; then
  echo "Nenhum servico de backend/infra encontrado para deploy."
  exit 1
fi

echo "[deploy] Subindo servicos: ${DEPLOY_SERVICES[*]}"
docker-compose -f "$COMPOSE_FILE" up -d --build "${DEPLOY_SERVICES[@]}"
