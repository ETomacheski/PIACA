CREATE TABLE sponsorships (
    id UUID DEFAULT gen_random_uuid(),
    start_date DATE,
    active BOOLEAN,
    sponsor_id UUID,
    pet_id UUID,
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_sponsorships PRIMARY KEY (id),
    CONSTRAINT fk_sponsorships_sponsor FOREIGN KEY (sponsor_id) REFERENCES sponsors(id),
    CONSTRAINT fk_sponsorships_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);