CREATE TABLE questions (
    id UUID DEFAULT gen_random_uuid(),
    code INTEGER,
    text TEXT NOT NULL,
    possible_answers TEXT,
    type VARCHAR(50) NOT NULL,
    created_at DATE,
    updated_at DATE,

    CONSTRAINT pk_questions PRIMARY KEY (id)
);