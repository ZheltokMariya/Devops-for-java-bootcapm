CREATE TABLE config (
    id SERIAL PRIMARY KEY,
    param VARCHAR(50) NOT NULL
);

INSERT INTO config(param) VALUES ('param1'), ('param2'), ('param3');