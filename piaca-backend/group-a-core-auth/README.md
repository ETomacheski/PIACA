# piaca-core-auth

Modulo de autenticacao da plataforma PIACA (Grupo A - Core & Auth).

Responsavel por:

- Cadastro e login de usuarios (`users`)
- Atribuicao de roles (`roles` + `user_roles`) - `ngo`, `protector`, `adopter`, `sponsor`, `admin`
- Emissao e verificacao de JWT
- Endpoint de perfil autenticado (`/auth/me`)

> Auditoria (logs) e signup diferenciado de ONG ainda nao foram implementados nesta branch.

## Arquitetura

Organizado em Clean Architecture:

```
src/
├── domain/                  regras puras (entities, errors)
├── application/use-cases/   SignupUser, LoginUser, GetUserProfile
├── infrastructure/
│   ├── db/                  pg pool, repositories, transaction runner
│   ├── security/            BcryptPasswordHasher, JwtTokenService
│   └── http/                express server, controller, middleware, routes
└── index.js                 composition root
```

Regras de dependencia: `http/db/security` → `application` → `domain`.
A camada de domain nao importa nada de infra.

## Como rodar (branch `feature/auth-user-login`)

Pre-requisitos: Docker + Docker Compose v2.

### 1. `.env` na raiz do repo

Na raiz (`/PIACA`), criar `.env`:

```bash
cd /caminho/do/PIACA
{ echo "JWT_SECRET=$(openssl rand -base64 48)"; echo "JWT_EXPIRES_IN=7d"; } > .env
```

### 2. Subir a stack

Se voce nao esta no grupo `docker`, prefixar com `sudo`. Para evitar:

```bash
sudo usermod -aG docker $USER && newgrp docker
```

Subir:

```bash
docker compose up -d --build postgres flyway piaca-core-auth traefik
```

### 3. Resetar o banco se a Flyway reclamar

Se o volume tiver migrations de runs anteriores com checksums diferentes (typical em dev):

```bash
docker compose down
docker volume rm piaca_pgdata     # nome pode variar - confira com `docker volume ls`
docker compose up -d --build postgres flyway piaca-core-auth traefik
```

### 4. Verificar

```bash
docker compose ps
docker compose logs piaca-core-auth --tail=20
```

Esperado nos logs: `piaca-core-auth listening on :3001`.

## Endpoints

Todas as rotas estao atras do Traefik em `http://localhost/auth/...`.

| Metodo | Rota             | Auth       | Descricao                              |
|--------|------------------|------------|----------------------------------------|
| GET    | `/auth/health`   | publico    | Health check (testa pool do Postgres)  |
| POST   | `/auth/signup`   | publico    | Cria user + role inicial, retorna JWT  |
| POST   | `/auth/login`    | publico    | Verifica credenciais, retorna JWT      |
| GET    | `/auth/me`       | Bearer JWT | Retorna perfil + roles do user logado  |

### Roles aceitas no signup

`ngo`, `protector`, `adopter`, `sponsor` (admin nao e atribuivel via signup).

## Como testar

### 1. Health

```bash
curl -s http://localhost/auth/health
# {"status":"ok"}
```

### 2. Signup

```bash
curl -s -X POST http://localhost/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@piaca.dev","password":"senha123","role":"protector"}' | jq
```

Resposta:

```json
{
  "token": "eyJhbGciOi...",
  "user": { "id": "...", "email": "teste@piaca.dev", "status": 1, ... },
  "roles": [{ "type": "protector", "description": "..." }]
}
```

### 3. Login

```bash
curl -s -X POST http://localhost/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@piaca.dev","password":"senha123"}' | jq
```

### 4. /auth/me

```bash
TOKEN="cole_o_token_aqui"
curl -s http://localhost/auth/me -H "Authorization: Bearer $TOKEN" | jq
```

### 5. Casos de erro

```bash
# email duplicado -> 409
curl -s -X POST http://localhost/auth/signup -H "Content-Type: application/json" \
  -d '{"email":"teste@piaca.dev","password":"senha123","role":"adopter"}'

# senha errada -> 401
curl -s -X POST http://localhost/auth/login -H "Content-Type: application/json" \
  -d '{"email":"teste@piaca.dev","password":"errada"}'

# role invalida -> 400
curl -s -X POST http://localhost/auth/signup -H "Content-Type: application/json" \
  -d '{"email":"a@b.com","password":"senha123","role":"hacker"}'

# token invalido -> 401
curl -s http://localhost/auth/me -H "Authorization: Bearer xxx"
```

### 6. Conferir no banco

```bash
docker compose exec postgres psql -U piaca_user -d piaca_db -c \
  "SELECT u.email, r.type_id
     FROM users u
     JOIN user_roles ur ON ur.user_id = u.id
     JOIN roles r ON r.id = ur.role_id;"
```

## Variaveis de ambiente

Lidas pelo container (definidas no `docker-compose.yml`):

| Var                | Default                     | Obrigatorio |
|--------------------|-----------------------------|-------------|
| `DB_HOST`          | `postgres`                  | nao         |
| `DB_PORT`          | `5432`                      | nao         |
| `DB_NAME`          | `piaca_db`                  | nao         |
| `DB_USER`          | `piaca_user`                | nao         |
| `DB_PASSWORD`      | `piaca_pass`                | nao         |
| `PORT`             | `3001`                      | nao         |
| `JWT_SECRET`       | -                           | **sim**     |
| `JWT_EXPIRES_IN`   | `7d`                        | nao         |

## Migrations relacionadas

- `V4__create_users.sql` - tabela `users` com `password_hash`
- `V5__create_roles.sql` - tabela `roles`
- `V14__user_relations.sql` - tabela `user_roles` (junction)
- `V35__seed_roles.sql` - UNIQUE em `roles.type_id` + seed das 5 roles
