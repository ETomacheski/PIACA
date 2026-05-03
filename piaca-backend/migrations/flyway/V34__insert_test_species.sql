INSERT INTO species_catalog (name, created_at, updated_at)
VALUES
    ('Cachorro', CURRENT_DATE, CURRENT_DATE)
ON CONFLICT (name) DO NOTHING;
