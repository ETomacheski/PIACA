CREATE TABLE donations (
    id UUID DEFAULT gen_random_uuid(),
    amount DECIMAL(10,2),
    payment_date DATE,
    method VARCHAR(50),
    sponsorship_id UUID,
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_donations PRIMARY KEY (id),
    CONSTRAINT fk_donations_sponsorship FOREIGN KEY (sponsorship_id) REFERENCES sponsorships(id)
);
