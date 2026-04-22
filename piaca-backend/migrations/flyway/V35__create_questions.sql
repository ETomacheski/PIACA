CREATE TABLE questions (
    id UUID DEFAULT gen_random_uuid(),
    code VARCHAR(100),
    text TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    created_at DATE,
    updated_at DATE,

    CONSTRAINT pk_questions PRIMARY KEY (id)
);