ALTER TABLE roles ADD CONSTRAINT uq_roles_type_id UNIQUE (type_id);

INSERT INTO roles (id, type_id, description, createdAt, updatedAt)
VALUES
    (gen_random_uuid(), 'ngo',       'ONG / organizacao protetora',           CURRENT_DATE, CURRENT_DATE),
    (gen_random_uuid(), 'protector', 'Protetor independente (pessoa fisica)', CURRENT_DATE, CURRENT_DATE),
    (gen_random_uuid(), 'adopter',   'Adotante (potencial ou efetivo)',       CURRENT_DATE, CURRENT_DATE),
    (gen_random_uuid(), 'sponsor',   'Padrinho - contribuinte recorrente',    CURRENT_DATE, CURRENT_DATE),
    (gen_random_uuid(), 'admin',     'Administrador da plataforma',           CURRENT_DATE, CURRENT_DATE);
