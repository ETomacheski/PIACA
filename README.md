# PIACA

## Visao Geral

O projeto esta organizado em tres camadas principais:

- `piaca-frontend/`: aplicacao web.
- `piaca-backend/`: modulos de backend por dominio, migrations e servicos HTTP.
- `piaca-infra/`: infraestrutura AWS com Terraform para rede, EC2 e RDS.

No ambiente local, a orquestracao e feita pelo arquivo `docker-compose.local.yml`. Ele sobe os servicos compartilhados e os modulos de backend em containers isolados, todos conectados na mesma rede Docker.

## Arquitetura da Infra

### Execucao local

O ambiente local usa os seguintes componentes:

- `traefik`: reverse proxy de entrada na porta `80`.
- `postgres`: banco PostgreSQL local na porta `5432`.
- `flyway`: aplicacao automatica das migrations do banco.
- modulos de backend: um container por grupo, exposto via rotas do Traefik.

Fluxo local:

```mermaid
flowchart LR
	U[Usuario] --> T[Traefik :80]
	T --> A[Group A /auth]
	T --> B[Group B /animals]
	T --> C[Group C /adoption]
	T --> D[Group D /godparenthood]
	T --> E[Example Module /example]
	A --> P[(Postgres)]
	B --> P
	C --> P
	D --> P
	E --> P
	F[Flyway] --> P
```

### Infraestrutura em nuvem

Os arquivos em `piaca-infra/` descrevem uma base simples na AWS:

- `network/`: cria a chave SSH e os security groups para EC2 e RDS.
- `ec2/`: cria uma instancia EC2, instala Docker e Docker Compose e sobe a aplicacao.
- `rds/`: cria uma instancia PostgreSQL gerenciada no RDS.

Desenho logico da nuvem:

```mermaid
flowchart LR
	I[Internet] --> EC2[EC2 com Docker Compose]
	EC2 --> RDS[(PostgreSQL RDS)]
```

## Estrutura dos Modulos

Cada grupo possui um modulo dedicado dentro de `piaca-backend/`:

- `group-a-core-auth/`: autenticacao e identidade.
- `group-b-pet-management/`: gestao de animais.
- `group-c-adoption-ai/`: recomendacoes e inteligencia para adocao.
- `group-d-godparenthood/`: padrinhamento e acompanhamento.
- `example-module/`: modulo de referencia para desenvolvimento e testes.

Cada modulo deve seguir a mesma ideia base:

- possuir seu proprio `Dockerfile`.
- iniciar seu app nas portas definidas para cada grupo (Exemplo: `traefik.http.services.core-auth.loadbalancer.server.port=3001`).
- consumir o banco pelas variaveis `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER` e `DB_PASSWORD`.

## Como Cada Grupo Pode Usar Seu Modulo

Cada grupo trabalha de forma isolada no proprio diretorio dentro de `piaca-backend/`, mas compartilha a mesma infraestrutura local:

1. implementar o codigo do modulo no seu diretorio.
2. garantir que o `Dockerfile` do modulo instala as dependencias e inicia a aplicacao.
3. descomentar o servico correspondente em `docker-compose.local.yml e docker-compose.yml`.
4. manter as variaveis de banco apontando para o servico `postgres` do compose local.

Rotas previstas para direcionamento (quando acessar esses endpoints, vai direcionar pro micro-servico de cada grupo correspondente):

- grupo A: `/auth`
- grupo B: `/animals`
- grupo C: `/adoption`
- grupo D: `/godparenthood`
- exemplo: `/example`

Se um grupo criar uma nova dependencia, alterar o `Dockerfile` ou modificar o codigo da aplicacao, precisa reconstruir a imagem para que o container receba a atualizacao.

## Banco de Dados e Migrations

As migrations ficam em `piaca-backend/migrations/flyway/`.

- `V1__create_test_table.sql`: cria a tabela de teste.
- `V2__insert_test_data.sql`: insere dados iniciais na tabela de teste.

O container `flyway` executa automaticamente essas migrations ao subir no ambiente local.

## Como Rodar Localmente

### 1. Pre-requisitos

Instale:

- Docker Desktop
- Docker Compose

### 2. Subir o ambiente local

Na raiz do repositorio:

```bash
docker volume create pgdata
docker compose -f docker-compose.local.yml up -d --build
```

Esse comando:

- constroi as imagens locais.
- sobe Traefik, Postgres, Flyway e os modulos habilitados.
- aplica as migrations do banco.
- cria volume no docker (pros dados do banco nao sumirem)

### 3. Acessar os servicos

Com o ambiente no ar, os endpoints ficam acessiveis pela porta `80` do Traefik:

- `http://localhost/example`
- `http://localhost/auth`
- `http://localhost/animals`
- `http://localhost/adoption`
- `http://localhost/godparenthood`

Os endpoints acima so responderao se o servico correspondente estiver habilitado no `docker-compose.local.yml`.

## Como Aplicar Novas Atualizacoes

Sempre que houver alteracao de codigo, dependencia ou configuracao de build, faca o rebuild do servico ou do ambiente inteiro. Sem isso, o container continua executando a imagem antiga.

### Rebuild de todo o ambiente

```bash
docker compose -f docker-compose.local.yml up -d --build
```

### Rebuild de um modulo especifico

Exemplo para o modulo de referencia:

```bash
docker compose -f docker-compose.local.yml up -d --build example-module
```

Exemplo para um modulo de grupo:

```bash
docker compose -f docker-compose.local.yml up -d --build piaca-core-auth
```

### Rodar novamente apenas as migrations

```bash
docker compose -f docker-compose.local.yml up flyway
```

## Comandos Uteis

### Ver containers em execucao

```bash
docker compose -f docker-compose.local.yml ps
```

### Ver logs de um servico

```bash
docker compose -f docker-compose.local.yml logs -f example-module
```

### Consultar o banco localmente

```bash
docker exec -it piaca-postgres psql -U piaca_user -d piaca_db
```

### Parar o ambiente

```bash
docker compose -f docker-compose.local.yml down
```

## Observacoes Importantes

- o arquivo `docker-compose.local.yml` e o ponto principal para desenvolvimento local.
- o arquivo `docker-compose.yml` representa uma configuracao mais generica, usando variaveis externas de ambiente para banco.
- os servicos dos grupos A, B, C e D estao comentados no compose local atual; cada grupo deve descomentar o seu servico quando for trabalhar nele.
- qualquer mudanca em `package.json`, bibliotecas instaladas, `Dockerfile` ou configuracao do container exige `build` novamente.

## Estrategia de Branches e Deploy

Fluxo sugerido para os grupos:

- cada grupo trabalha na sua branch (exemplo: `group-a/feature-x`).
- abre PR para `develop`.
- `develop` representa ambiente de desenvolvimento (EC2 dev).
- `main` representa ambiente de producao (EC2 prod).
- deploy para producao acontece apenas em push na `main`.

Resumo de promocao:

1. branch do grupo -> `develop` (valida em dev)
2. `develop` -> `main` (promove para prod)

## Pipelines de Deploy (GitHub Actions)

Foram criados dois workflows:

- `.github/workflows/deploy-frontend.yml`
- `.github/workflows/deploy-services.yml`

Comportamento:

- push em `develop` faz deploy na EC2 de desenvolvimento.
- push em `main` faz deploy na EC2 de producao.
- pipeline de frontend reage a mudancas em `piaca-frontend/**`.
- pipeline de servicos reage a mudancas em `piaca-backend/**`.

O deploy remoto usa o script:

- `scripts/deploy-ec2.sh`

Esse script atualiza o codigo para a branch do evento e executa `docker compose up -d --build` somente no stack correspondente (frontend ou services).

Antes de subir o compose, o deploy sincroniza as variaveis de banco para `.env` usando o script `scripts/sync-env-from-ssm.sh`.

## Secrets Necessarios no GitHub

Configure os seguintes secrets no repositorio:

- `DEV_EC2_HOST`: IP ou DNS da EC2 de desenvolvimento.
- `PROD_EC2_HOST`: IP ou DNS da EC2 de producao.
- `EC2_SSH_USER`: usuario SSH da EC2 (exemplo: `ec2-user`).
- `EC2_SSH_PRIVATE_KEY`: chave privada com acesso SSH as EC2.
- `EC2_APP_DIR` (opcional): caminho do repo na EC2. Default usado: `/home/ec2-user/app`.

Secrets extras recomendados para separar dev e prod por completo:

- `DEV_EC2_APP_DIR` (opcional): caminho do repo na EC2 de dev.
- `PROD_EC2_APP_DIR` (opcional): caminho do repo na EC2 de prod.

Nao e necessario salvar `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER` e `DB_PASSWORD` no GitHub.
Esses valores sao publicados no AWS SSM Parameter Store pelo Terraform do RDS e lidos pela EC2 com IAM Role.

Prefixos SSM usados:

- dev: `/piaca/dev/db/*`
- prod: `/piaca/prod/db/*`

## Ajustes Recomendados de Infra

Para os pipelines funcionarem bem em dev e prod, o ideal e ter duas instancias EC2:

- uma EC2 para `develop`.
- uma EC2 para `main`.

Tambem e recomendado evoluir o Terraform para:

- manter estados separados por camada (`network`, `rds`, `ec2`) e aplicar com arquivos `.tfvars`.

Exemplos de arquivos para facilitar:

- `piaca-infra/rds/all-envs.tfvars.example`
- `piaca-infra/ec2/all-envs.tfvars.example`

Com a organizacao atual, `rds/main.tf` cria os dois bancos (`dev` e `prod`) no mesmo `apply`.

Exemplo de aplicacao do RDS:

```bash
cd piaca-infra/rds
terraform init
terraform apply -var-file=all-envs.tfvars
```

Da mesma forma, `ec2/main.tf` cria as duas EC2 (`dev` e `prod`) no mesmo `apply`.

Depois, para EC2:

```bash
cd ../ec2
terraform init
terraform apply -var-file=all-envs.tfvars
```
