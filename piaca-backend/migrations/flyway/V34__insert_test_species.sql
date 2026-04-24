INSERT INTO species_catalog (name, createdat, updatedat)
VALUES
    ('Cachorro', CURRENT_DATE, CURRENT_DATE)
ON CONFLICT (name) DO NOTHING;
