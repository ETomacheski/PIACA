#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Uso: $0 <branch> [app_dir] [compose_file] [services...]"
  exit 1
fi

BRANCH="$1"
APP_DIR="${2:-/home/ec2-user/app}"
COMPOSE_FILE="${3:-docker-compose.yml}"
DEPLOY_SERVICES=()

if [ "$#" -ge 4 ]; then
  DEPLOY_SERVICES=("${@:4}")
fi

cd "$APP_DIR"

echo "[deploy] Atualizando codigo da branch $BRANCH"
git fetch origin
git checkout -B "$BRANCH" "origin/$BRANCH"
git reset --hard "origin/$BRANCH"

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Arquivo compose nao encontrado: $COMPOSE_FILE"
  exit 1
fi

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  else
    docker-compose "$@"
  fi
}

if [ "${#DEPLOY_SERVICES[@]}" -gt 0 ]; then
  echo "[deploy] Subindo servicos selecionados: ${DEPLOY_SERVICES[*]}"
  compose -f "$COMPOSE_FILE" up -d --build "${DEPLOY_SERVICES[@]}"
else
  echo "[deploy] Subindo stack completa"
  compose -f "$COMPOSE_FILE" up -d --build
fi
