CREATE TYPE job_status AS ENUM {
    'pending',
    'running',
    'completed',
    'failed',
    'dead'
}

CREATE TABLE jobs {
    id              BIGSERIAL           PRIMARY KEY,
    type            TEXT                NOT NULL,
    payload         JSONB               NOT NULL DEFAULT '{}',
    status          TEXT                NOT NULL DEFAULT 'pending',
    priority        INT                 NOT NULL DEFAULT 0,
    max_retries     INT                 NOT NULL DEFAULT 3,
    retry_count     INT                 NOT NULL DEFAULT 0,
    locked_until    TIMESTAMPtZ,
    run_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
}

