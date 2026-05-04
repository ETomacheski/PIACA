CREATE TABLE attachments (
    id UUID DEFAULT gen_random_uuid(),
    occurrence_id UUID,
    file_name VARCHAR(255),
    s3_url TEXT,
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_attachments PRIMARY KEY (id),
    CONSTRAINT fk_attachments_occurrence FOREIGN KEY (occurrence_id) REFERENCES occurrences(id)
);
