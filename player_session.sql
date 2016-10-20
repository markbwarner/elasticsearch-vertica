CREATE TABLE
    public.player_session
    (
        senderid INT NOT NULL,
        sessionid VARCHAR(20),
        device VARCHAR(100),
        platform VARCHAR(30),
        game VARCHAR(30),
        game_version INT,
        session_date DATE,
		session_minutes INT
    );

ALTER TABLE
    public.player_session ADD CONSTRAINT C_PRIMARY PRIMARY KEY (senderid,sessionid);

CREATE PROJECTION public.player_session
/*+createtype(L)*/
( senderid, sessionid, device, platform, game,
game_version, session_date, session_minutes) AS
SELECT
    player_session.senderid,
    player_session.sessionid,
    player_session.device,
    player_session.platform,
    player_session.game,
    player_session.game_version,
    player_session.session_date,
    player_session.session_minutes
FROM
    public.player_session
ORDER BY
    player_session.senderid SEGMENTED BY hash(player_session.senderid,player_session.sessionid) ALL NODES
    KSAFE 0;

SELECT
    MARK_DESIGN_KSAFE(0);
