# Group C — Adoption AI

## Setup

Instale as dependências:

```bash
pip install -r requirements.txt
```

Para rodar o servidor localmente:

```bash
uvicorn app.main:app --reload
```

e acessar http://127.0.0.1:8000/docs para acessar o swagger da API.


> **Recomendado:** instale a extensão [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff) no VS Code para formatação e linting automático, mantendo o código padronizado entre todos.

---

## Status

Estrutura inicial montada — **nada testado ainda**. Os arquivos de adoption servem como exemplo do padrão a ser seguido.

---

## Estrutura do projeto

```
app/
├── api/
│   └── routers/
│       └── adoption.py     # rotas HTTP
├── models/
│   └── adoption.py         # tabelas do banco (SQLAlchemy)
├── schemas/
│   └── adoption.py         # formatos de entrada/saída (Pydantic)
├── repositories/
│   └── adoption.py         # queries no banco
├── services/
│   └── adoption.py         # lógica de negócio
├── dependencies/
│   └── database.py         # conexão com o banco
└── core/
    └── config.py           # variáveis de ambiente
```

---

## Padrão a seguir

O fluxo é: **Router → Service → Repository → Banco**

### `models/`
Define as tabelas do banco usando SQLAlchemy. Todo model herda de `DataModel`.

```python
from sqlalchemy.orm import Mapped, mapped_column
from app.dependencies.database import DataModel

class Adoption(DataModel):
    __tablename__ = "adoptions"

    id: Mapped[int] = mapped_column(primary_key=True)
    pet_name: Mapped[str]
```

### `schemas/`
Define os formatos de request/response usando Pydantic. São os dados que entram e saem da API — separados dos models do banco.

```python
from pydantic import BaseModel

class Adoption(BaseModel):
    id: str
    pet_name: str
```

### `repositories/`
Só queries no banco, sem lógica nenhuma. Recebe a sessão via injeção de dependência.

```python
from fastapi import Depends
from sqlalchemy.orm import Session
from app.dependencies.database import piaca_db

class AdoptionRepository:
    def __init__(self, session: Session = Depends(piaca_db.get_session)):
        self.session = session

    def get_all(self) -> list[...]:
        return self.session.query(...).all()
```

### `services/`
Toda a lógica de negócio fica aqui: validações de regra, decisões do domínio, orquestração de múltiplos repositories. Recebe o repository via injeção de dependência.

```python
from fastapi import Depends
from app.repositories.adoption import AdoptionRepository

class AdoptionService:
    def __init__(self, repo: AdoptionRepository = Depends()):
        self.repo = repo

    def list_all(self):
        return self.repo.get_all()

    def adopt(self, animal_id: int, user_id: int):
        # regra de negócio aqui — não no router
        ...
```

### `api/routers/`
Só define as rotas e delega tudo pro service. Não contém lógica.

```python
from fastapi import APIRouter, Depends
from app.services.adoption import AdoptionService
from app.schemas.adoption import Adoption

router = APIRouter()

@router.get("/")
def get_all_adoptions(service: AdoptionService = Depends()) -> list[Adoption]:
    return service.list_all()
```

---

## Variáveis de ambiente

Copie `.env.example` para `.env` e ajuste os valores:
É daqui que config vai puxar as variáveis.
```bash
cp .env.example .env
```


## Gemini Client
Adicionei um client base para o gemini. O uso é pareciso com o database.



# Formatação:
Instalem a extensão no VSCode: Ruff
e coloquem isso aqui (dentro do objeto principal e único) no `.vscode/settings.json` de vocês desse repo:
```json
{
    "[python]": {
        "editor.defaultFormatter": "charliermarsh.ruff",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
            "source.organizeImports": "explicit"
        }
    }
}
```
Isso vai fazer com que o código e os imports sejam formatados no padrão do Python automaticamente. 