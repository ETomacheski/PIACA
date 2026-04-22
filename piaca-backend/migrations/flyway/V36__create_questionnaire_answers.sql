CREATE TABLE questionnaire_answers (
    id UUID DEFAULT gen_random_uuid(),
    submittedAt DATE,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_questionnaire_answers PRIMARY KEY (id),
    CONSTRAINT fk_questionnaire_answers_user
        FOREIGN KEY (user_id) REFERENCES users(id)
);