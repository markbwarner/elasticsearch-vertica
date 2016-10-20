CREATE TABLE
    public.player_dimension
    (
        senderid INT NOT NULL,
        player_type VARCHAR(16),
        player_name VARCHAR(256),
        player_gender VARCHAR(8),
        nickname VARCHAR(8),
        household_id INT,
        player_address VARCHAR(256),
        player_city VARCHAR(64),
        player_state CHAR(2),
        player_region VARCHAR(64),
        marital_status VARCHAR(32),
        player_age INT,
        avg_level INT,
        total_points INT,
        occupation VARCHAR(64),
        ltv INT,
        membership_card INT,
        player_since DATE,
        favorite_game VARCHAR(30),
        avg_min_game INT,
        last_update DATE
    );

ALTER TABLE
    public.player_dimension ADD CONSTRAINT C_PRIMARY PRIMARY KEY (senderid);

CREATE PROJECTION public.player_dimension
/*+createtype(L)*/
( senderid, player_type, player_name, player_gender, nickname, household_id,
player_address, player_city, player_state, player_region, marital_status, player_age,
avg_level, total_points, occupation, ltv, membership_card,
player_since, favorite_game, avg_min_game, last_update ) AS
SELECT
    player_dimension.senderid,
    player_dimension.player_type,
    player_dimension.player_name,
    player_dimension.player_gender,
    player_dimension.nickname,
    player_dimension.household_id,
    player_dimension.player_address,
    player_dimension.player_city,
    player_dimension.player_state,
    player_dimension.player_region,
    player_dimension.marital_status,
    player_dimension.player_age,
    player_dimension.avg_level,
    player_dimension.total_points,
    player_dimension.occupation,
    player_dimension.ltv,
    player_dimension.membership_card,
    player_dimension.player_since,
    player_dimension.favorite_game,
    player_dimension.avg_min_game,
    player_dimension.last_update
FROM
    public.player_dimension
ORDER BY
    player_dimension.senderid SEGMENTED BY hash(player_dimension.senderid) ALL NODES
    KSAFE 0;

SELECT
    MARK_DESIGN_KSAFE(0);
