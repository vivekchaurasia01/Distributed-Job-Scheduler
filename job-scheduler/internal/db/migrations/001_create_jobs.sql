CREATE TYPE job_status AS ENUM {
    'pending',
    'running',
    'completed',
    'failed',
    'dead'
};

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
};


CREATE INDEX idx_jobs_scheduler
    ON jobs (priority DESC, run_at ASC, created_at ASC)
    WHERE status IN ('pending', 'failed');

CREATE INDEX idx_jobs_watchdog
    ON jobs (locked_until ASC)
    WHERE status = 'running';


CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON jobs
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_updated_at();