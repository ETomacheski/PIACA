# PIACA

## Nuvem (resumo)

Em producao, o projeto roda em uma unica EC2 publica.

- a EC2 sobe toda a stack com Docker Compose
- o Postgres roda em container na mesma EC2
- o Traefik recebe as requisicoes HTTP e roteia para os modulos
- deploy remoto e basicamente atualizar codigo e executar docker compose up -d --build

## Arquitetura de roteamento (Traefik)

```mermaid
flowchart LR
	U[Usuario / Browser] --> T[Traefik :80]
	T --> EX[/example -> example-module]
	T --> A[/auth -> piaca-core-auth]
	T --> B[/animals -> piaca-pet-management]
	T --> C[/adoption -> piaca-adoption-ai]
	T --> D[/godparenthood -> piaca-godparenthood]
	EX --> P[(Postgres)]
	A --> P
	B --> P
	C --> P
	D --> P
```

## Como rodar

O projeto roda inteiro com um unico comando Docker Compose.

Pre-requisitos:

- Docker
- Docker Compose v2

Na raiz do repositorio:

```bash
docker compose up -d --build
```

Esse comando sobe:

- traefik
- postgres
- flyway
- modulos habilitados no docker-compose.yml

## Variaveis de ambiente

As variaveis de banco ja tem valor default no proprio docker-compose.yml:

- DB_HOST=postgres
- DB_PORT=5432
- DB_NAME=piaca_db
- DB_USER=piaca_user
- DB_PASSWORD=piaca_pass

## Rebuild de um modulo especifico

Para rebuildar e subir so um modulo:

```bash
docker compose up -d --build <nome-do-servico>
```

Exemplo:

```bash
docker compose up -d --build example-module
```

## Comandos basicos

Ver status:

```bash
docker compose ps
```

Ver logs:

```bash
docker compose logs -f
```

Parar tudo:

```bash
docker compose down
```
