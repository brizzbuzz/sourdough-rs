CREATE TABLE IF NOT EXISTS leagues
(
    id                        BIGSERIAL    NOT NULL,
    apple_sports_canonical_id VARCHAR(255) NOT NULL,
    sport                     VARCHAR(255) NOT NULL,
    display_name              VARCHAR(255) NOT NULL,
    abbreviation              VARCHAR(255) NOT NULL,
    created_at                TIMESTAMP    NOT NULL,
    updated_at                TIMESTAMP    NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS leagues_canonical_id_index ON leagues (apple_sports_canonical_id);

CREATE TABLE IF NOT EXISTS teams
(
    id                        BIGSERIAL    NOT NULL,
    apple_sports_canonical_id VARCHAR(255) NOT NULL,
    display_name              VARCHAR(255) NOT NULL,
    created_at                TIMESTAMP    NOT NULL,
    updated_at                TIMESTAMP    NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (apple_sports_canonical_id)
);

CREATE INDEX IF NOT EXISTS teams_canonical_id_index ON teams (apple_sports_canonical_id);

CREATE TABLE IF NOT EXISTS events
(
    id                        BIGSERIAL    NOT NULL,
    apple_sports_canonical_id VARCHAR(255) NOT NULL,
    league_id                 BIGINT       NOT NULL REFERENCES leagues (id),
    short_name                VARCHAR(255) NOT NULL,
    progress_status           VARCHAR(50)  NOT NULL, -- InProgress, Final, etc.
    version                   VARCHAR(50)  NOT NULL,
    start_time                TIMESTAMP    NOT NULL,
    sport_name                VARCHAR(100) NOT NULL,
    coverage_reliable         BOOLEAN      NOT NULL DEFAULT true,
    period_type               VARCHAR(50)  NOT NULL, -- Quarter, Half, Period
    current_period            INTEGER      NOT NULL,
    total_periods             INTEGER      NOT NULL,
    created_at                TIMESTAMP    NOT NULL,
    updated_at                TIMESTAMP    NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (apple_sports_canonical_id)
);

CREATE INDEX IF NOT EXISTS events_canonical_id_index ON events (apple_sports_canonical_id);
CREATE INDEX IF NOT EXISTS events_league_id_index ON events (league_id);
CREATE INDEX IF NOT EXISTS events_status_index ON events (progress_status);

CREATE TABLE IF NOT EXISTS event_competitors
(
    id           BIGSERIAL        NOT NULL,
    event_id     BIGINT           NOT NULL REFERENCES events (id),
    team_id      BIGINT           NOT NULL REFERENCES teams (id),
    score        DOUBLE PRECISION NOT NULL DEFAULT 0,
    is_home_team BOOLEAN          NOT NULL,
    created_at   TIMESTAMP        NOT NULL,
    updated_at   TIMESTAMP        NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (event_id, team_id)
);

CREATE TABLE IF NOT EXISTS event_statistics
(
    id             BIGSERIAL    NOT NULL,
    event_id       BIGINT       NOT NULL REFERENCES events (id),
    statistic_type VARCHAR(100) NOT NULL,
    value          DECIMAL      NOT NULL,
    created_at     TIMESTAMP    NOT NULL,
    updated_at     TIMESTAMP    NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS event_statistics_event_id_index ON event_statistics (event_id);

CREATE TABLE IF NOT EXISTS event_metadata
(
    id            BIGSERIAL    NOT NULL,
    event_id      BIGINT       NOT NULL REFERENCES events (id),
    metadata_type VARCHAR(100) NOT NULL,
    value         TEXT         NOT NULL,
    created_at    TIMESTAMP    NOT NULL,
    updated_at    TIMESTAMP    NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS event_metadata_event_id_index ON event_metadata (event_id);