CREATE TABLE reports (
    id UUID DEFAULT gen_random_uuid(),
    report TEXT,
    adopter_id UUID,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_reports PRIMARY KEY (id),
    CONSTRAINT fk_reports_adopter FOREIGN KEY (adopter_id) REFERENCES adopters(id)
);
