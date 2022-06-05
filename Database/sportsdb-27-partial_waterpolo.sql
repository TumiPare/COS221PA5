/*============================================================================*/
/* DDL SCRIPT                                                                 */
/*============================================================================*/
/* Title:      SportsDB                                                       */
/* Filename:   sportsdb-27.hf                                                 */
/* Platform:   MySQL 3                                                        */
/* Version:    8                                                              */
/* Generated:  February 10, 2011                                              */
/*============================================================================*/

/*============================================================================*/
/* DOCUMENT TABLES                                                            */
/*============================================================================*/

CREATE TABLE latest_revisions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    revision_id VARCHAR(255) NOT NULL,
    latest_document_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN latest_revisions.revision_id
a string from the SportsML
*/

CREATE TABLE db_info (
    version VARCHAR(100) NOT NULL DEFAULT 16
);

CREATE TABLE documents (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    doc_id VARCHAR(75) NOT NULL,
    publisher_id INTEGER NOT NULL,
    date_time DATETIME,
    title VARCHAR(255),
    language VARCHAR(100),
    priority VARCHAR(100),
    revision_id VARCHAR(255),
    stats_coverage VARCHAR(100),
    document_fixture_id INTEGER NOT NULL,
    source_id INTEGER,
    db_loading_date_time DATETIME
);

/*
COMMENT ON COLUMN documents.doc_id
the key originally found in the document. Should be globally unique. Not a Foreign Key, even though it ends in _id.
*/

/*
COMMENT ON COLUMN documents.publisher_id
the publisher of this document
*/

/*
COMMENT ON COLUMN documents.date_time
Timestamp for when this document was originally published.
*/

/*
COMMENT ON COLUMN documents.title
person | team | league | etc.
*/

/*
COMMENT ON COLUMN documents.priority
event | sub_season | league_phase | lifetime
*/

/*
COMMENT ON COLUMN documents.revision_id
a common key that links together different versions of the same document. Generally matches the doc_id of the first published draft of this document.
*/

/*
COMMENT ON COLUMN documents.source_id
An alternative publisher_id for "republishers" of information.
*/

/*
COMMENT ON COLUMN documents.db_loading_date_time
Timestamp for when this document was loaded into the DB.
*/

CREATE TABLE persons_documents (
    person_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN db_info.version
version of this database
*/


CREATE TABLE document_classes (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(100)
);

/*
COMMENT ON COLUMN document_classes.name
event-summary, news, statistics, etc. Should be called document_class_key, really.
*/

CREATE TABLE document_contents (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    sportsml VARCHAR(200),
    sportsml_blob TEXT,
    abstract TEXT,
    abstract_blob TEXT
);

CREATE TABLE document_fixtures (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    fixture_key VARCHAR(100),
    publisher_id INTEGER NOT NULL,
    name VARCHAR(100),
    document_class_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN document_fixtures.id
Unique per fixture_key + publisher_id
*/

/*
COMMENT ON COLUMN document_fixtures.name
OUTMODED.... should use display_names instead
*/

CREATE TABLE affiliations_documents (
    affiliation_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

CREATE TABLE teams_documents (
    team_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

CREATE TABLE events_documents (
    event_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

/*============================================================================*/
/* DOCUMENT PACKAGES TABLES                                                   */
/*============================================================================*/

CREATE TABLE document_packages (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    package_key VARCHAR(100),
    package_name VARCHAR(100),
    date_time DATE
);

/*
COMMENT ON COLUMN document_packages.package_key
eg, top-news-nba
*/

/*
COMMENT ON COLUMN document_packages.package_name
eg, "Top NBA News"
*/

/*
COMMENT ON COLUMN document_packages.date_time
time this package was originally published
*/

CREATE TABLE document_package_entry (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    document_package_id INTEGER NOT NULL,
    `rank` VARCHAR(100),
    document_id INTEGER NOT NULL,
    headline VARCHAR(100),
    short_headline VARCHAR(100)
);

/*============================================================================*/
/* PERSON TABLES                                                              */
/*============================================================================*/

CREATE TABLE persons (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    person_key VARCHAR(100) NOT NULL,
    publisher_id INTEGER NOT NULL,
    gender VARCHAR(20),
    birth_date VARCHAR(30),
    death_date VARCHAR(30),
    final_resting_location_id INTEGER,
    birth_location_id INTEGER,
    hometown_location_id INTEGER,
    residence_location_id INTEGER,
    death_location_id INTEGER
);

/*
COMMENT ON COLUMN persons.id
Unique per person_key + publisher_id
*/

CREATE TABLE roles (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    role_key VARCHAR(100) NOT NULL,
    role_name VARCHAR(100),
    comment VARCHAR(100)
);

/*
COMMENT ON COLUMN roles.role_key
player | coach | manager | owner| umpire | etc.
*/

/*
COMMENT ON COLUMN roles.role_name
Display name for the key
*/

CREATE TABLE positions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    affiliation_id INTEGER NOT NULL,
    abbreviation VARCHAR(100) NOT NULL
);

CREATE TABLE person_event_metadata (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    status VARCHAR(100),
    health VARCHAR(100),
    weight VARCHAR(100),
    role_id INTEGER,
    position_id INTEGER,
    team_id INTEGER,
    lineup_slot INTEGER,
    lineup_slot_sequence INTEGER
);

/*
COMMENT ON COLUMN person_event_metadata.status
benched | started | played | scratched
*/

CREATE TABLE injury_phases (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    injury_status VARCHAR(100),
    injury_type VARCHAR(100),
    injury_comment VARCHAR(100),
    disabled_list VARCHAR(100),
    start_date_time DATETIME,
    end_date_time DATETIME,
    season_id INTEGER,
    phase_type VARCHAR(100),
    injury_side VARCHAR(100)
);

CREATE TABLE person_phases (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    membership_type VARCHAR(40) NOT NULL,
    membership_id INTEGER NOT NULL,
    role_id INTEGER,
    role_status VARCHAR(40),
    phase_status VARCHAR(40),
    uniform_number VARCHAR(20),
    regular_position_id INTEGER,
    regular_position_depth VARCHAR(40),
    height VARCHAR(100),
    weight VARCHAR(100),
    start_date_time DATETIME,
    start_season_id INTEGER,
    end_date_time DATETIME,
    end_season_id INTEGER,
    entry_reason VARCHAR(40),
    exit_reason VARCHAR(40),
    selection_level INTEGER,
    selection_sublevel INTEGER,
    selection_overall INTEGER,
    duration VARCHAR(32),
    phase_type VARCHAR(40),
    subphase_type VARCHAR(40)
);

/*
COMMENT ON COLUMN person_phases.person_id
the person whose phase this is
*/

/*
COMMENT ON COLUMN person_phases.membership_type
teams | affiliations
*/

/*
COMMENT ON COLUMN person_phases.membership_id
the team_id or affiliation_id
*/

/*
COMMENT ON COLUMN person_phases.role_id
the role the person has in this team or affiliation
*/

/*
COMMENT ON COLUMN person_phases.role_status
further metadata on the role (free-agent, signed, retired | drafted | playing)
*/

/*
COMMENT ON COLUMN person_phases.phase_status
active | inactive
*/

/*
COMMENT ON COLUMN person_phases.regular_position_id
where person usually plays.
*/

/*
COMMENT ON COLUMN person_phases.regular_position_depth
indicates whether player is first string or second string in that regular position
*/

/*
COMMENT ON COLUMN person_phases.start_date_time
if NULL, indicates phase start is unknown
*/

/*
COMMENT ON COLUMN person_phases.start_season_id
if NULL, indicates phase start is unknown
*/

/*
COMMENT ON COLUMN person_phases.end_date_time
if NULL, indicates person is still a member
*/

/*
COMMENT ON COLUMN person_phases.end_season_id
if NULL, indicates person is still a member
*/

/*============================================================================*/
/* LOCATION TABLES                                                            */
/*============================================================================*/

CREATE TABLE sites (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    site_key VARCHAR(128) NOT NULL,
    publisher_id INTEGER NOT NULL,
    location_id INTEGER
);

CREATE TABLE addresses (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    language VARCHAR(100),
    suite VARCHAR(100),
    `floor` VARCHAR(100),
    building VARCHAR(100),
    street_number VARCHAR(100),
    street_prefix VARCHAR(100),
    street VARCHAR(100),
    street_suffix VARCHAR(100),
    neighborhood VARCHAR(100),
    district VARCHAR(100),
    locality VARCHAR(100),
    county VARCHAR(100),
    region VARCHAR(100),
    postal_code VARCHAR(100),
    country VARCHAR(100)
);

/*
COMMENT ON COLUMN addresses.locality
city or town
*/

/*
COMMENT ON COLUMN addresses.region
state or province
*/

CREATE TABLE locations (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    area VARCHAR(100),
    country VARCHAR(100),
    timezone VARCHAR(100),
    latitude VARCHAR(100),
    longitude VARCHAR(100),
    country_code VARCHAR(100)
);

/*
COMMENT ON COLUMN locations.timezone
In tz format, see: http://www.twinsun.com/tz/tz-link.htm
*/


/*============================================================================*/
/* UTILITY TABLES                                                             */
/*============================================================================*/

CREATE TABLE display_names (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    language VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id INTEGER NOT NULL,
    full_name VARCHAR(100),
    first_name VARCHAR(100),
    middle_name VARCHAR(100),
    last_name VARCHAR(100),
    alias VARCHAR(100),
    abbreviation VARCHAR(100),
    short_name VARCHAR(100),
    prefix VARCHAR(20),
    suffix VARCHAR(20)
);

/*
COMMENT ON COLUMN display_names.entity_type
person | team | affiliation tier | site | position
*/


CREATE TABLE publishers (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    publisher_key VARCHAR(100) NOT NULL,
    publisher_name VARCHAR(100)
);

CREATE TABLE key_roots (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    key_type VARCHAR(100)
);

/*
COMMENT ON COLUMN key_roots.key_type
persons | teams | affiliations | events | etc.
*/

CREATE TABLE key_aliases (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    key_id INTEGER NOT NULL,
    key_root_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN key_aliases.key_id
A person_id, team_id, etc. Use key_roots.key_type to determine which table this ID is for.
*/

CREATE TABLE sports_property (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sports_property_type VARCHAR(100),
    sports_property_id INTEGER,
    formal_name VARCHAR(100) NOT NULL,
    value VARCHAR(255)
);


/*============================================================================*/
/* ORGANIZATION TABLES                                                        */
/*============================================================================*/

CREATE TABLE teams (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    team_key VARCHAR(100) NOT NULL,
    publisher_id INTEGER NOT NULL,
    home_site_id INTEGER
);

CREATE TABLE team_phases (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    team_id INTEGER NOT NULL,
    start_season_id INTEGER,
    end_season_id INTEGER,
    affiliation_id INTEGER NOT NULL,
    start_date_time VARCHAR(100),
    end_date_time VARCHAR(100),
    phase_status VARCHAR(40),
    role_id INTEGER
);

/*
COMMENT ON COLUMN team_phases.phase_status
active | inactive
*/

/*
COMMENT ON COLUMN team_phases.role_id
identifies the relationship between a minor league team and parent MLB ballclub
*/

CREATE TABLE affiliations (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    affiliation_key VARCHAR(100) NOT NULL,
    affiliation_type VARCHAR(100),
    publisher_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN affiliations.affiliation_type
division | conference | caliber | organization | sport
*/

CREATE TABLE affiliation_phases (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    affiliation_id INTEGER NOT NULL,
    root_id INTEGER,
    ancestor_affiliation_id INTEGER,
    start_season_id INTEGER,
    start_date_time DATETIME,
    end_season_id INTEGER,
    end_date_time DATETIME
);

CREATE TABLE rankings (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    document_fixture_id INTEGER,
    participant_type VARCHAR(100),
    participant_id INTEGER,
    issuer VARCHAR(100),
    ranking_type VARCHAR(100),
    ranking_value VARCHAR(100),
    ranking_value_previous VARCHAR(100),
    date_coverage_type VARCHAR(100),
    date_coverage_id INTEGER
);


/*============================================================================*/
/* STATS TABLES                                                               */
/*============================================================================*/

CREATE TABLE stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    stat_repository_type VARCHAR(100),
    stat_repository_id INTEGER NOT NULL,
    stat_holder_type VARCHAR(100),
    stat_holder_id INTEGER,
    stat_coverage_type VARCHAR(100),
    stat_coverage_id INTEGER,
    stat_membership_type VARCHAR(40),
    stat_membership_id INTEGER,
    context VARCHAR(40) NOT NULL
);

/*
COMMENT ON COLUMN stats.stat_repository_type
name of the table that has this stat_id as its id
*/

/*
COMMENT ON COLUMN stats.stat_repository_id
id in that table for this row
*/

/*
COMMENT ON COLUMN stats.stat_holder_type
persons | teams | affiliations | etc.
*/

/*
COMMENT ON COLUMN stats.stat_holder_id
id of that person, team, etc.
*/

/*
COMMENT ON COLUMN stats.stat_coverage_type
events | sub_seasons | affiliations | *_phases | etc.
*/

/*
COMMENT ON COLUMN stats.stat_coverage_id
id of that event, sub_season, etc.
*/

/*
COMMENT ON COLUMN stats.context
event if this is a confirmed stat, event-play if an unofficial mid-game update, etc.
*/

CREATE TABLE core_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    score VARCHAR(100),
    score_opposing VARCHAR(100),
    score_attempts VARCHAR(100),
    score_attempts_opposing VARCHAR(100),
    score_percentage VARCHAR(100),
    score_percentage_opposing VARCHAR(100),
    time_played_event VARCHAR(40),
    time_played_total VARCHAR(40),
    time_played_event_average VARCHAR(40),
    events_played VARCHAR(40),
    events_started VARCHAR(40),
    position_id INTEGER
);

CREATE TABLE penalty_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    count INTEGER,
    type VARCHAR(100),
    value INTEGER
);



/*============================================================================*/
/* PERIOD, SEASON AND EVENT TABLES (right section with pink and orange tables)*/
/*============================================================================*/

CREATE TABLE events (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_key VARCHAR(100) NOT NULL,
    publisher_id INTEGER NOT NULL,
    start_date_time DATETIME,
    site_id INTEGER,
    site_alignment VARCHAR(100),
    event_status VARCHAR(100),
    duration VARCHAR(100),
    attendance VARCHAR(100),
    last_update DATETIME,
    event_number VARCHAR(32),
    round_number VARCHAR(32),
    time_certainty VARCHAR(100),
    broadcast_listing VARCHAR(255),
    start_date_time_local DATETIME,
    medal_event VARCHAR(100),
    series_index VARCHAR(40)
);

CREATE TABLE affiliations_events (
    affiliation_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL
);

CREATE TABLE events_sub_seasons (
    event_id INTEGER NOT NULL,
    sub_season_id INTEGER NOT NULL
);

CREATE TABLE document_fixtures_events (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    document_fixture_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    latest_document_id INTEGER NOT NULL,
    last_update DATETIME
);

CREATE TABLE seasons (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    season_key INTEGER NOT NULL,
    publisher_id INTEGER NOT NULL,
    league_id INTEGER,
    start_date_time DATETIME,
    end_date_time DATETIME
);

/*
COMMENT ON COLUMN seasons.id
Unique per season_key + publisher_id
*/

CREATE TABLE sub_seasons (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sub_season_key VARCHAR(100) NOT NULL,
    season_id INTEGER NOT NULL,
    sub_season_type VARCHAR(100) NOT NULL,
    start_date_time DATETIME,
    end_date_time DATETIME
);

/*
COMMENT ON COLUMN sub_seasons.id
Unique per season_id + type
*/

/*
COMMENT ON COLUMN sub_seasons.sub_season_type
pre | regular | post | exhibition | all-star
*/

CREATE TABLE participants_events (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_type VARCHAR(100) NOT NULL,
    participant_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    alignment VARCHAR(100),
    score VARCHAR(100),
    event_outcome VARCHAR(100),
    `rank` INTEGER,
    result_effect VARCHAR(100),
    score_attempts INTEGER,
    sort_order VARCHAR(100),
    score_type VARCHAR(100)
);


CREATE TABLE periods (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_event_id INTEGER NOT NULL,
    period_value VARCHAR(100),
    score VARCHAR(100),
    score_attempts INTEGER,
    `rank` VARCHAR(100),
    sub_score_key VARCHAR(100),
    sub_score_type VARCHAR(100),
    sub_score_name VARCHAR(100)
);


CREATE TABLE sub_periods (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    period_id INTEGER NOT NULL,
    sub_period_value VARCHAR(100),
    score VARCHAR(100),
    score_attempts INTEGER
);

/*
COMMENT ON TABLE sub_periods
Especially for Tennis. sub_period is for game, period is for set, score is for total number of sets won.
*/

/*
COMMENT ON COLUMN events.start_date_time
Normalized to UTC
*/

CREATE TABLE weather_conditions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    temperature VARCHAR(100),
    temperature_units VARCHAR(40),
    humidity VARCHAR(100),
    clouds VARCHAR(100),
    wind_direction VARCHAR(100),
    wind_velocity VARCHAR(100),
    weather_code VARCHAR(100)
);

CREATE TABLE awards (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_type VARCHAR(100) NOT NULL,
    participant_id INTEGER NOT NULL,
    award_type VARCHAR(100),
    name VARCHAR(100),
    total INTEGER,
    `rank` VARCHAR(100),
    award_value VARCHAR(100),
    currency VARCHAR(100),
    date_coverage_type VARCHAR(100),
    date_coverage_id INTEGER
);

CREATE TABLE records (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_type VARCHAR(100),
    participant_id INTEGER,
    record_type VARCHAR(100),
    record_label VARCHAR(100),
    record_value VARCHAR(100),
    previous_value VARCHAR(100),
    date_coverage_type VARCHAR(100),
    date_coverage_id INTEGER,
    comment VARCHAR(512)
);

/*============================================================================*/
/* WAGERING LINE TABLES                                                       */
/*============================================================================*/

CREATE TABLE bookmakers (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_key VARCHAR(100),
    publisher_id INTEGER NOT NULL,
    location_id INTEGER
);

CREATE TABLE wagering_moneylines (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    date_time DATETIME,
    team_id INTEGER NOT NULL,
    person_id INTEGER,
    rotation_key VARCHAR(100),
    comment VARCHAR(255),
    vigorish VARCHAR(100),
    line VARCHAR(100),
    line_opening VARCHAR(100),
    prediction VARCHAR(100)
);

/*
COMMENT ON COLUMN wagering_moneylines.id
Unique per bookmaker_key + event_id + date_time + (team_id | person_id)
*/

/*
COMMENT ON COLUMN wagering_moneylines.date_time
Time that line was set
*/

CREATE TABLE wagering_odds_lines (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    date_time DATETIME,
    team_id INTEGER NOT NULL,
    person_id INTEGER,
    rotation_key VARCHAR(100),
    comment VARCHAR(255),
    numerator VARCHAR(100),
    denominator VARCHAR(100),
    prediction VARCHAR(100),
    payout_calculation VARCHAR(100),
    payout_amount VARCHAR(100)
);

/*
COMMENT ON COLUMN wagering_odds_lines.id
Unique per bookmaker_key + event_id + date_time + (team_id | person_id)
*/

/*
COMMENT ON COLUMN wagering_odds_lines.date_time
Time that line was set
*/

CREATE TABLE wagering_runlines (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    date_time DATETIME,
    team_id INTEGER NOT NULL,
    person_id INTEGER,
    rotation_key VARCHAR(100),
    comment VARCHAR(255),
    vigorish VARCHAR(100),
    `line` VARCHAR(100),
    line_opening VARCHAR(100),
    line_value VARCHAR(100),
    prediction VARCHAR(100)
);

/*
COMMENT ON COLUMN wagering_runlines.id
Unique per bookmaker_key + event_id + date_time + (team_id | person_id)
*/

/*
COMMENT ON COLUMN wagering_runlines.date_time
Time that line was set
*/

CREATE TABLE wagering_straight_spread_lines (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    date_time DATETIME,
    team_id INTEGER NOT NULL,
    person_id INTEGER,
    rotation_key VARCHAR(100),
    comment VARCHAR(255),
    vigorish VARCHAR(100),
    line_value VARCHAR(100),
    line_value_opening VARCHAR(100),
    prediction VARCHAR(100)
);

/*
COMMENT ON COLUMN wagering_straight_spread_lines.id
Unique per bookmaker_key + event_id + date_time + (team_id | person_id)
*/

/*
COMMENT ON COLUMN wagering_straight_spread_lines.date_time
Time that line was set
*/

CREATE TABLE wagering_total_score_lines (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    date_time DATETIME,
    team_id INTEGER NOT NULL,
    person_id INTEGER,
    rotation_key VARCHAR(100),
    comment VARCHAR(255),
    vigorish VARCHAR(100),
    line_over VARCHAR(100),
    line_under VARCHAR(100),
    total VARCHAR(100),
    total_opening VARCHAR(100),
    prediction VARCHAR(100)
);

/*
COMMENT ON COLUMN wagering_total_score_lines.id
Unique per bookmaker_key + event_id + date_time + (team_id | person_id)
*/

/*
COMMENT ON COLUMN wagering_total_score_lines.date_time
Time that line was set
*/

/*============================================================================*/
/* STANDINGS TABLES                                                           */
/*============================================================================*/

CREATE TABLE standings (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    affiliation_id INTEGER NOT NULL,
    standing_type VARCHAR(100),
    sub_season_id INTEGER NOT NULL,
    last_updated VARCHAR(100),
    source VARCHAR(100)
);

/*
COMMENT ON COLUMN standings.affiliation_id
eg, ID for league-key
*/

/*
COMMENT ON COLUMN standings.standing_type
division | conference | playoffs | wild-card | etc.
*/

/*
COMMENT ON COLUMN standings.last_updated
date timestamp that these standings were last updated
*/

/*
COMMENT ON COLUMN standings.source
pre-published | real-time
*/

CREATE TABLE standing_subgroups (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    standing_id INTEGER NOT NULL,
    affiliation_id INTEGER NOT NULL,
    alignment_scope VARCHAR(100),
    competition_scope VARCHAR(100),
    competition_scope_id VARCHAR(100),
    duration_scope VARCHAR(100),
    scoping_label VARCHAR(100),
    site_scope VARCHAR(100)
);

/*
COMMENT ON COLUMN standing_subgroups.affiliation_id
id for, say, American League East division
*/

CREATE TABLE outcome_totals (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    standing_subgroup_id INTEGER NOT NULL,
    outcome_holder_type VARCHAR(100),
    outcome_holder_id INTEGER,
    `rank` VARCHAR(100),
    wins VARCHAR(100),
    losses VARCHAR(100),
    ties VARCHAR(100),
    wins_overtime INTEGER,
    losses_overtime INTEGER,
    undecideds VARCHAR(100),
    winning_percentage VARCHAR(100),
    points_scored_for VARCHAR(100),
    points_scored_against VARCHAR(100),
    points_difference VARCHAR(100),
    standing_points VARCHAR(100),
    streak_type VARCHAR(100),
    streak_duration VARCHAR(100),
    streak_total VARCHAR(100),
    streak_start DATETIME,
    streak_end DATETIME,
    events_played INTEGER,
    games_back VARCHAR(100),
    result_effect VARCHAR(100),
    sets_against VARCHAR(100),
    sets_for VARCHAR(100)
);

/*
COMMENT ON COLUMN outcome_totals.outcome_holder_type
team | player | etc
*/

/*
COMMENT ON COLUMN outcome_totals.outcome_holder_id
the team_id or player_id or etc
*/

/*
COMMENT ON COLUMN outcome_totals.points_difference
games back, for baseball
*/

/*
COMMENT ON COLUMN outcome_totals.streak_type
win | loss | tie | score | assist | point
*/

/*
COMMENT ON COLUMN outcome_totals.streak_duration
number of days
*/

/*
COMMENT ON COLUMN outcome_totals.streak_total
number of games
*/

/*============================================================================*/
/* MEDIA TABLES                                                               */
/*============================================================================*/

CREATE TABLE media (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `object_id` INTEGER,
    source_id INTEGER,
    revision_id INTEGER,
    media_type VARCHAR(100),
    publisher_id INTEGER NOT NULL,
    date_time VARCHAR(100),
    credit_id INTEGER NOT NULL,
    db_loading_date_time DATETIME,
    creation_location_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN media.object_id
parallel to the doc_id... the original unique ID provided by the publisher
*/

/*
COMMENT ON COLUMN media.source_id
an ID that was used upstream from the current publisher object_id
*/

/*
COMMENT ON COLUMN media.media_type
photo | audio | video
*/

CREATE TABLE affiliations_media (
    affiliation_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);

CREATE TABLE documents_media (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL,
    media_caption_id INTEGER NOT NULL
);

/*
COMMENT ON TABLE documents_media
identifies the relationship between a document and its zero-or-more Media Objects
*/

CREATE TABLE media_contents (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    media_id INTEGER NOT NULL,
    object VARCHAR(100),
    `format` VARCHAR(100),
    mime_type VARCHAR(100),
    height VARCHAR(100),
    width VARCHAR(100),
    duration VARCHAR(100),
    file_size VARCHAR(100),
    resolution VARCHAR(100)
);

/*
COMMENT ON COLUMN media_contents.resolution
main | thumbnail | low-bandwidth | high-bandwidth
*/

CREATE TABLE media_keywords (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    keyword VARCHAR(100),
    media_id INTEGER NOT NULL
);

CREATE TABLE media_captions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    media_id INTEGER NOT NULL,
    caption_type VARCHAR(100),
    caption VARCHAR(100),
    caption_author_id INTEGER NOT NULL,
    language VARCHAR(100),
    caption_size VARCHAR(100)
);

/*
COMMENT ON COLUMN media_captions.caption_type
main | headline | name, to give three common examples, from longest to shortest length
*/

/*
COMMENT ON COLUMN media_captions.caption_size
size of caption, in characters
*/

CREATE TABLE persons_media (
    person_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN persons_media.person_id
Unique per person_key + publisher_id
*/

CREATE TABLE teams_media (
    team_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);

CREATE TABLE events_media (
    event_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);


/*============================================================================*/
/* GENRERIC EVENT STATE TABLES                                                */
/*============================================================================*/

CREATE TABLE event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state INTEGER,
    sequence_number INTEGER,
    period_value VARCHAR(100),
    period_time_elapsed VARCHAR(100),
    period_time_remaining VARCHAR(100),
    minutes_elapsed VARCHAR(100),
    period_minutes_elapsed VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

CREATE TABLE event_action_fouls (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_state_id INTEGER NOT NULL,
    foul_name VARCHAR(100),
    foul_result VARCHAR(100),
    foul_type VARCHAR(100),
    fouler_id VARCHAR(100),
    recipient_type VARCHAR(100),
    recipient_id INTEGER,
    comment VARCHAR(512)
);

CREATE TABLE event_action_plays (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_state_id INTEGER NOT NULL,
    play_type VARCHAR(100),
    score_attempt_type VARCHAR(100),
    play_result VARCHAR(100),
    comment VARCHAR(512)
);

CREATE TABLE event_action_participants (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_state_id INTEGER NOT NULL,
    event_action_play_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    participant_role VARCHAR(100)
);

CREATE TABLE event_action_penalties (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_state_id INTEGER NOT NULL,
    penalty_type VARCHAR(100),
    penalty_level VARCHAR(100),
    caution_level VARCHAR(100),
    recipient_type VARCHAR(100),
    recipient_id INTEGER,
    comment VARCHAR(512)
);

CREATE TABLE event_action_substitutions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_state_id INTEGER NOT NULL,
    person_original_id INTEGER NOT NULL,
    person_original_position_id INTEGER NOT NULL,
    person_replacing_id INTEGER NOT NULL,
    person_replacing_position_id INTEGER NOT NULL,
    substitution_reason VARCHAR(100),
    comment VARCHAR(512)
);


/*============================================================================*/
/* TABLE CONSTRAINTS                                                          */
/*============================================================================*/

ALTER TABLE addresses
    ADD CONSTRAINT FK_add_loc_id__loc_id
    FOREIGN KEY (location_id) REFERENCES locations (id);

ALTER TABLE affiliations
    ADD CONSTRAINT FK_aff_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE seasons
    ADD CONSTRAINT FK_sea_lea_id__aff_id
    FOREIGN KEY (league_id) REFERENCES affiliations (id);

ALTER TABLE seasons
    ADD CONSTRAINT FK_sea_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE affiliation_phases
    ADD CONSTRAINT FK_seasons_affiliation_phases1
    FOREIGN KEY (end_season_id) REFERENCES seasons (id);

ALTER TABLE affiliation_phases
    ADD CONSTRAINT FK_seasons_affiliation_phases
    FOREIGN KEY (start_season_id) REFERENCES seasons (id);

ALTER TABLE affiliation_phases
    ADD CONSTRAINT FK_affiliations_affiliation_phases1
    FOREIGN KEY (ancestor_affiliation_id) REFERENCES affiliations (id);

ALTER TABLE affiliation_phases
    ADD CONSTRAINT FK_affiliations_affiliation_phases
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE document_fixtures
    ADD CONSTRAINT FK_doc_fix_doc_cla_id__doc_cla_id
    FOREIGN KEY (document_class_id) REFERENCES document_classes (id);

ALTER TABLE document_fixtures
    ADD CONSTRAINT FK_doc_fix_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE documents
    ADD CONSTRAINT FK_doc_sou_id__pub_id
    FOREIGN KEY (source_id) REFERENCES publishers (id);

ALTER TABLE documents
    ADD CONSTRAINT FK_doc_doc_fix_id__doc_fix_id
    FOREIGN KEY (document_fixture_id) REFERENCES document_fixtures (id);

ALTER TABLE documents
    ADD CONSTRAINT FK_doc_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE affiliations_documents
    ADD CONSTRAINT FK_aff_doc_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE affiliations_documents
    ADD CONSTRAINT FK_aff_doc_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE sites
    ADD CONSTRAINT FK_sit_loc_id__loc_id
    FOREIGN KEY (location_id) REFERENCES locations (id);

ALTER TABLE sites
    ADD CONSTRAINT FK_sit_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE events
    ADD CONSTRAINT FK_eve_sit_id__sit_id
    FOREIGN KEY (site_id) REFERENCES sites (id);

ALTER TABLE events
    ADD CONSTRAINT FK_eve_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE affiliations_events
    ADD CONSTRAINT FK_aff_eve_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE affiliations_events
    ADD CONSTRAINT FK_aff_eve_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE persons
    ADD CONSTRAINT FK_persons_final_resting_location_id_locations_id
    FOREIGN KEY (final_resting_location_id) REFERENCES locations (id);

ALTER TABLE persons
    ADD CONSTRAINT FK_per_bir_loc_id__loc_id
    FOREIGN KEY (birth_location_id) REFERENCES locations (id);

ALTER TABLE persons
    ADD CONSTRAINT FK_per_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE persons
    ADD CONSTRAINT FK_per_dea_loc_id__loc_id
    FOREIGN KEY (death_location_id) REFERENCES locations (id);

ALTER TABLE persons
    ADD CONSTRAINT FK_per_res_loc_id__loc_id
    FOREIGN KEY (residence_location_id) REFERENCES locations (id);

ALTER TABLE persons
    ADD CONSTRAINT FK_per_hom_loc_id__loc_id
    FOREIGN KEY (hometown_location_id) REFERENCES locations (id);

ALTER TABLE media
    ADD CONSTRAINT FK_med_cre_id__per_id
    FOREIGN KEY (credit_id) REFERENCES persons (id);

ALTER TABLE media
    ADD CONSTRAINT FK_med_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE media
    ADD CONSTRAINT FK_med_cre_loc_id__loc_id
    FOREIGN KEY (creation_location_id) REFERENCES locations (id);

ALTER TABLE affiliations_media
    ADD CONSTRAINT FK_aff_med_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE affiliations_media
    ADD CONSTRAINT FK_aff_med_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE teams
    ADD CONSTRAINT FK_tea_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE teams
    ADD CONSTRAINT FK_tea_hom_sit_id__sit_id
    FOREIGN KEY (home_site_id) REFERENCES sites (id);

ALTER TABLE positions
    ADD CONSTRAINT FK_pos_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE bookmakers
    ADD CONSTRAINT FK_boo_loc_id__loc_id
    FOREIGN KEY (location_id) REFERENCES locations (id);

ALTER TABLE bookmakers
    ADD CONSTRAINT FK_boo_pub_id__pub_id
    FOREIGN KEY (publisher_id) REFERENCES publishers (id);

ALTER TABLE document_contents
    ADD CONSTRAINT FK_doc_con_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE document_fixtures_events
    ADD CONSTRAINT FK_doc_fix_eve_lat_doc_id__doc_id
    FOREIGN KEY (latest_document_id) REFERENCES documents (id);

ALTER TABLE document_fixtures_events
    ADD CONSTRAINT FK_doc_fix_eve_doc_fix_id__doc_fix_id
    FOREIGN KEY (document_fixture_id) REFERENCES document_fixtures (id);

ALTER TABLE document_fixtures_events
    ADD CONSTRAINT FK_doc_fix_eve_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE document_package_entry
    ADD CONSTRAINT FK_doc_pac_ent_doc_pac_id__doc_pac_id
    FOREIGN KEY (document_package_id) REFERENCES document_packages (id);

ALTER TABLE document_package_entry
    ADD CONSTRAINT FK_doc_pac_ent_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE media_captions
    ADD CONSTRAINT FK_med_cap_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE media_captions
    ADD CONSTRAINT FK_med_cap_cap_aut_id__per_id
    FOREIGN KEY (caption_author_id) REFERENCES persons (id);

ALTER TABLE documents_media
    ADD CONSTRAINT FK_doc_med_med_cap_id__med_cap_id
    FOREIGN KEY (media_caption_id) REFERENCES media_captions (id);

ALTER TABLE documents_media
    ADD CONSTRAINT FK_doc_med_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE documents_media
    ADD CONSTRAINT FK_doc_med_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE event_states
    ADD CONSTRAINT FK_events_event_states
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE event_action_fouls
    ADD CONSTRAINT FK_event_states_event_action_fouls
    FOREIGN KEY (event_state_id) REFERENCES event_states (id);

ALTER TABLE event_action_plays
    ADD CONSTRAINT FK_event_states_event_action_plays
    FOREIGN KEY (event_state_id) REFERENCES event_states (id);

ALTER TABLE event_action_participants
    ADD CONSTRAINT FK_event_action_plays_event_action_participants
    FOREIGN KEY (event_action_play_id) REFERENCES event_action_plays (id);

ALTER TABLE event_action_participants
    ADD CONSTRAINT FK_persons_event_action_participants
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE event_action_participants
    ADD CONSTRAINT FK_event_states_event_action_participants
    FOREIGN KEY (event_state_id) REFERENCES event_states (id);

ALTER TABLE event_action_penalties
    ADD CONSTRAINT FK_event_states_event_action_penalties
    FOREIGN KEY (event_state_id) REFERENCES event_states (id);

ALTER TABLE event_action_substitutions
    ADD CONSTRAINT FK_persons_event_action_substitutions1
    FOREIGN KEY (person_replacing_id) REFERENCES persons (id);

ALTER TABLE event_action_substitutions
    ADD CONSTRAINT FK_persons_event_action_substitutions
    FOREIGN KEY (person_original_id) REFERENCES persons (id);

ALTER TABLE event_action_substitutions
    ADD CONSTRAINT FK_event_states_event_action_substitutions
    FOREIGN KEY (event_state_id) REFERENCES event_states (id);

ALTER TABLE event_action_substitutions
    ADD CONSTRAINT FK_positions_event_action_substitutions1
    FOREIGN KEY (person_replacing_position_id) REFERENCES positions (id);

ALTER TABLE event_action_substitutions
    ADD CONSTRAINT FK_positions_event_action_substitutions
    FOREIGN KEY (person_original_position_id) REFERENCES positions (id);

ALTER TABLE events_documents
    ADD CONSTRAINT FK_eve_doc_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE events_documents
    ADD CONSTRAINT FK_eve_doc_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE events_media
    ADD CONSTRAINT FK_eve_med_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE events_media
    ADD CONSTRAINT FK_eve_med_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE sub_seasons
    ADD CONSTRAINT FK_sub_sea_sea_id__sea_id
    FOREIGN KEY (season_id) REFERENCES seasons (id);

ALTER TABLE events_sub_seasons
    ADD CONSTRAINT FK_eve_sub_sea_sub_sea_id__sub_sea_id
    FOREIGN KEY (sub_season_id) REFERENCES sub_seasons (id);

ALTER TABLE events_sub_seasons
    ADD CONSTRAINT FK_eve_sub_sea_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE injury_phases
    ADD CONSTRAINT FK_inj_pha_sea_id__sea_id
    FOREIGN KEY (season_id) REFERENCES seasons (id);

ALTER TABLE injury_phases
    ADD CONSTRAINT FK_inj_pha_per_id__per_id
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE key_aliases
    ADD CONSTRAINT FK_key_roots_key_aliases
    FOREIGN KEY (key_root_id) REFERENCES key_roots (id);

ALTER TABLE latest_revisions
    ADD CONSTRAINT FK_lat_rev_lat_doc_id__doc_id
    FOREIGN KEY (latest_document_id) REFERENCES documents (id);

ALTER TABLE media_contents
    ADD CONSTRAINT FK_med_con_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE media_keywords
    ADD CONSTRAINT FK_med_key_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE standings
    ADD CONSTRAINT FK_sta_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE standings
    ADD CONSTRAINT FK_sta_sub_sea_id__sub_sea_id
    FOREIGN KEY (sub_season_id) REFERENCES sub_seasons (id);

ALTER TABLE standing_subgroups
    ADD CONSTRAINT FK_sta_sub_sta_id__sta_id
    FOREIGN KEY (standing_id) REFERENCES standings (id);

ALTER TABLE standing_subgroups
    ADD CONSTRAINT FK_sta_sub_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE outcome_totals
    ADD CONSTRAINT FK_out_tot_sta_sub_id__sta_sub_id
    FOREIGN KEY (standing_subgroup_id) REFERENCES standing_subgroups (id);

ALTER TABLE participants_events
    ADD CONSTRAINT FK_par_eve_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE periods
    ADD CONSTRAINT FK_per_par_eve_id__par_eve_id
    FOREIGN KEY (participant_event_id) REFERENCES participants_events (id);

ALTER TABLE person_event_metadata
    ADD CONSTRAINT FK_per_eve_met_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE person_event_metadata
    ADD CONSTRAINT FK_per_eve_met_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE person_event_metadata
    ADD CONSTRAINT FK_per_eve_met_per_id__per_id
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE person_event_metadata
    ADD CONSTRAINT FK_per_eve_met_pos_id__pos_id
    FOREIGN KEY (position_id) REFERENCES positions (id);

ALTER TABLE person_event_metadata
    ADD CONSTRAINT FK_per_eve_met_rol_id__rol_id
    FOREIGN KEY (role_id) REFERENCES roles (id);

ALTER TABLE person_phases
    ADD CONSTRAINT FK_per_pha_rol_id__rol_id
    FOREIGN KEY (role_id) REFERENCES roles (id);

ALTER TABLE person_phases
    ADD CONSTRAINT FK_per_pha_reg_pos_id__pos_id
    FOREIGN KEY (regular_position_id) REFERENCES positions (id);

ALTER TABLE person_phases
    ADD CONSTRAINT FK_per_pha_sta_sea_id__sea_id
    FOREIGN KEY (start_season_id) REFERENCES seasons (id);

ALTER TABLE person_phases
    ADD CONSTRAINT FK_per_pha_per_id__per_id
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE person_phases
    ADD CONSTRAINT FK_per_pha_end_sea_id__sea_id
    FOREIGN KEY (end_season_id) REFERENCES seasons (id);

ALTER TABLE persons_documents
    ADD CONSTRAINT FK_per_doc_per_id__per_id
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE persons_documents
    ADD CONSTRAINT FK_per_doc_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE persons_media
    ADD CONSTRAINT FK_per_med_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE persons_media
    ADD CONSTRAINT FK_per_med_per_id__per_id
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE sub_periods
    ADD CONSTRAINT FK_sub_per_per_id__per_id
    FOREIGN KEY (period_id) REFERENCES periods (id);

ALTER TABLE team_phases
    ADD CONSTRAINT FK_tea_aff_pha_rol_id__rol_id
    FOREIGN KEY (role_id) REFERENCES roles (id);

ALTER TABLE team_phases
    ADD CONSTRAINT FK_tea_aff_pha_end_sea_id__sea_id
    FOREIGN KEY (end_season_id) REFERENCES seasons (id);

ALTER TABLE team_phases
    ADD CONSTRAINT FK_tea_aff_pha_sta_sea_id__sea_id
    FOREIGN KEY (start_season_id) REFERENCES seasons (id);

ALTER TABLE team_phases
    ADD CONSTRAINT FK_tea_aff_pha_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE team_phases
    ADD CONSTRAINT FK_tea_aff_pha_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE teams_documents
    ADD CONSTRAINT FK_tea_doc_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE teams_documents
    ADD CONSTRAINT FK_tea_doc_doc_id__doc_id
    FOREIGN KEY (document_id) REFERENCES documents (id);

ALTER TABLE teams_media
    ADD CONSTRAINT FK_tea_med_med_id__med_id
    FOREIGN KEY (media_id) REFERENCES media (id);

ALTER TABLE teams_media
    ADD CONSTRAINT FK_tea_med_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE wagering_moneylines
    ADD CONSTRAINT FK_wag_mon_boo_id__boo_id
    FOREIGN KEY (bookmaker_id) REFERENCES bookmakers (id);

ALTER TABLE wagering_moneylines
    ADD CONSTRAINT FK_wag_mon_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE wagering_moneylines
    ADD CONSTRAINT FK_wag_mon_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE wagering_odds_lines
    ADD CONSTRAINT FK_wag_odd_lin_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE wagering_odds_lines
    ADD CONSTRAINT FK_wag_odd_lin_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE wagering_odds_lines
    ADD CONSTRAINT FK_wag_odd_lin_boo_id__boo_id
    FOREIGN KEY (bookmaker_id) REFERENCES bookmakers (id);

ALTER TABLE wagering_runlines
    ADD CONSTRAINT FK_wag_run_boo_id__boo_id
    FOREIGN KEY (bookmaker_id) REFERENCES bookmakers (id);

ALTER TABLE wagering_runlines
    ADD CONSTRAINT FK_wag_run_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE wagering_runlines
    ADD CONSTRAINT FK_wag_run_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE wagering_straight_spread_lines
    ADD CONSTRAINT FK_wag_str_spr_lin_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE wagering_straight_spread_lines
    ADD CONSTRAINT FK_wag_str_spr_lin_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE wagering_straight_spread_lines
    ADD CONSTRAINT FK_wag_str_spr_lin_boo_id__boo_id
    FOREIGN KEY (bookmaker_id) REFERENCES bookmakers (id);

ALTER TABLE wagering_total_score_lines
    ADD CONSTRAINT FK_wag_tot_sco_lin_boo_id__boo_id
    FOREIGN KEY (bookmaker_id) REFERENCES bookmakers (id);

ALTER TABLE wagering_total_score_lines
    ADD CONSTRAINT FK_wag_tot_sco_lin_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE wagering_total_score_lines
    ADD CONSTRAINT FK_wag_tot_sco_lin_tea_id__tea_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE weather_conditions
    ADD CONSTRAINT FK_wea_con_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

/*============================================================================*/
/* INDEXES                                                                    */
/*============================================================================*/

ALTER TABLE locations
ADD INDEX IDX_locations_1 (country_code);

ALTER TABLE addresses
ADD INDEX IDX_addresses_1 (locality);

ALTER TABLE addresses
ADD INDEX IDX_addresses_2 (region);

ALTER TABLE addresses
ADD INDEX IDX_addresses_3 (postal_code);

ALTER TABLE addresses
ADD INDEX IDX_FK_add_loc_id__loc_id (location_id);

ALTER TABLE publishers
ADD INDEX IDX_publishers_1 (publisher_key);

ALTER TABLE affiliations
ADD INDEX IDX_affiliations_1 (affiliation_key);

ALTER TABLE affiliations
ADD INDEX IDX_affiliations_2 (affiliation_type);

ALTER TABLE affiliations
ADD INDEX IDX_affiliations_3 (affiliation_key, affiliation_type, publisher_id);

ALTER TABLE affiliations
ADD INDEX IDX_FK_aff_pub_id__pub_id (publisher_id);

ALTER TABLE seasons
ADD INDEX IDX_FK_sea_lea_id__aff_id (league_id);

ALTER TABLE seasons
ADD INDEX IDX_FK_sea_pub_id__pub_id (publisher_id);

ALTER TABLE seasons
ADD INDEX IDX_seasons_1 (season_key);

ALTER TABLE document_fixtures
ADD INDEX IDX_document_fixtures_1 (fixture_key);

ALTER TABLE document_fixtures
ADD INDEX IDX_FK_doc_fix_doc_cla_id__doc_cla_id (document_class_id);

ALTER TABLE document_fixtures
ADD INDEX IDX_FK_doc_fix_pub_id__pub_id (publisher_id);

ALTER TABLE documents
ADD INDEX IDX_documents_1 (doc_id);

ALTER TABLE documents
ADD INDEX IDX_documents_3 (date_time);

ALTER TABLE documents
ADD INDEX IDX_documents_4 (priority);

ALTER TABLE documents
ADD INDEX IDX_documents_5 (revision_id);

ALTER TABLE documents
ADD INDEX IDX_FK_doc_doc_fix_id__doc_fix_id (document_fixture_id);

ALTER TABLE documents
ADD INDEX IDX_FK_doc_pub_id__pub_id (publisher_id);

ALTER TABLE documents
ADD INDEX IDX_FK_doc_sou_id__pub_id (source_id);

ALTER TABLE sites
ADD INDEX IDX_FK_sit_loc_id__loc_id (location_id);

ALTER TABLE sites
ADD INDEX IDX_FK_sit_pub_id__pub_id (publisher_id);

ALTER TABLE sites
ADD INDEX IDX_sites_1 (site_key);

ALTER TABLE events
ADD INDEX IDX_events_1 (event_key);

ALTER TABLE events
ADD INDEX IDX_FK_eve_pub_id__pub_id (publisher_id);

ALTER TABLE events
ADD INDEX IDX_FK_eve_sit_id__sit_id (site_id);

ALTER TABLE persons
ADD INDEX IDX_FK_per_pub_id__pub_id (publisher_id);

ALTER TABLE persons
ADD INDEX IDX_persons_1 (person_key);

ALTER TABLE teams
ADD INDEX IDX_teams_team_key (team_key);

ALTER TABLE positions
ADD INDEX IDX_FK_pos_aff_id__aff_id (affiliation_id);

ALTER TABLE positions
ADD INDEX IDX_positions_1 (abbreviation);

ALTER TABLE db_info
ADD INDEX IDX_db_info_1 (version);

ALTER TABLE display_names
ADD INDEX IDX_display_names_1 (entity_id);

ALTER TABLE display_names
ADD INDEX IDX_display_names_2 (entity_type);

ALTER TABLE document_classes
ADD INDEX IDX_document_classes_1 (name);

ALTER TABLE document_contents
ADD INDEX IDX_FK_doc_con_doc_id__doc_id (document_id);

ALTER TABLE document_fixtures_events
ADD INDEX IDX_FK_doc_fix_eve_doc_fix_id__doc_fix_id (document_fixture_id);

ALTER TABLE document_fixtures_events
ADD INDEX IDX_FK_doc_fix_eve_eve_id__eve_id (event_id);

ALTER TABLE document_fixtures_events
ADD INDEX IDX_FK_doc_fix_eve_lat_doc_id__doc_id (latest_document_id);

ALTER TABLE event_states
ADD INDEX IDX_event_states_context (context);

ALTER TABLE event_states
ADD INDEX IDX_event_states_seq_num (sequence_number);

ALTER TABLE sub_seasons
ADD INDEX IDX_FK_sub_sea_sea_id__sea_id (season_id);

ALTER TABLE sub_seasons
ADD INDEX IDX_sub_seasons_1 (sub_season_key);

ALTER TABLE sub_seasons
ADD INDEX IDX_sub_seasons_2 (sub_season_type);

ALTER TABLE injury_phases
ADD INDEX IDX_FK_inj_pha_per_id__per_id (person_id);

ALTER TABLE injury_phases
ADD INDEX IDX_FK_inj_pha_sea_id__sea_id (season_id);

ALTER TABLE injury_phases
ADD INDEX IDX_injury_phases_2 (injury_status);

ALTER TABLE injury_phases
ADD INDEX IDX_injury_phases_3 (start_date_time);

ALTER TABLE injury_phases
ADD INDEX IDX_injury_phases_4 (end_date_time);

ALTER TABLE key_roots
ADD INDEX IDX_key_aliases_1 (key_type);

ALTER TABLE key_aliases
ADD INDEX IDX_key_aliases_2 (key_id);

ALTER TABLE latest_revisions
ADD INDEX IDX_FK_lat_rev_lat_doc_id__doc_id (latest_document_id);

ALTER TABLE latest_revisions
ADD INDEX IDX_latest_revisions_1 (revision_id);

ALTER TABLE participants_events
ADD INDEX IDX_FK_par_eve_eve_id__eve_id (event_id);

ALTER TABLE participants_events
ADD INDEX IDX_participants_events_1 (participant_type);

ALTER TABLE participants_events
ADD INDEX IDX_participants_events_2 (participant_id);

ALTER TABLE participants_events
ADD INDEX IDX_participants_events_3 (alignment);

ALTER TABLE participants_events
ADD INDEX IDX_participants_events_4 (event_outcome);

ALTER TABLE periods
ADD INDEX IDX_FK_per_par_eve_id__par_eve_id (participant_event_id);

ALTER TABLE roles
ADD INDEX IDX_roles_1 (role_key);

ALTER TABLE person_event_metadata
ADD INDEX IDX_FK_per_eve_met_eve_id__eve_id (event_id);

ALTER TABLE person_event_metadata
ADD INDEX IDX_FK_per_eve_met_per_id__per_id (person_id);

ALTER TABLE person_event_metadata
ADD INDEX IDX_FK_per_eve_met_pos_id__pos_id (position_id);

ALTER TABLE person_event_metadata
ADD INDEX IDX_FK_per_eve_met_rol_id__rol_id (role_id);

ALTER TABLE person_event_metadata
ADD INDEX IDX_FK_teams_person_event_metadata (team_id);

ALTER TABLE person_event_metadata
ADD INDEX IDX_person_event_metadata_1 (status);

ALTER TABLE person_phases
ADD INDEX IDX_FK_per_pha_per_id__per_id (person_id);

ALTER TABLE person_phases
ADD INDEX IDX_FK_per_pha_reg_pos_id__pos_id (regular_position_id);

ALTER TABLE person_phases
ADD INDEX IDX_person_phases_1 (membership_type);

ALTER TABLE person_phases
ADD INDEX IDX_person_phases_2 (membership_id);

ALTER TABLE person_phases
ADD INDEX IDX_person_phases_3 (phase_status);

ALTER TABLE stats
ADD INDEX IDX_stats_1 (stat_repository_type);

ALTER TABLE stats
ADD INDEX IDX_stats_2 (stat_repository_id);

ALTER TABLE stats
ADD INDEX IDX_stats_3 (stat_holder_type);

ALTER TABLE stats
ADD INDEX IDX_stats_4 (stat_holder_id);

ALTER TABLE stats
ADD INDEX IDX_stats_5 (stat_coverage_type);

ALTER TABLE stats
ADD INDEX IDX_stats_6 (stat_coverage_id);

ALTER TABLE stats
ADD INDEX IDX_stats_7 (context);

ALTER TABLE sub_periods
ADD INDEX IDX_FK_sub_per_per_id__per_id (period_id);

ALTER TABLE weather_conditions
ADD INDEX IDX_FK_wea_con_eve_id__eve_id (event_id);

DELETE FROM db_info;
INSERT INTO db_info (version) VALUES ('27');


/*============================================================================*/
/* WATERPOLO TABLES                                                           */
/*============================================================================*/

CREATE TABLE `users` (
  `id` int NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `key` varchar(45) DEFAULT NULL
);

CREATE TABLE `waterpolo_action_fouls` (
  `id` int NOT NULL,
  `event_state_id` int NOT NULL,
  `foul_name` varchar(100) DEFAULT NULL,
  `foul_result` varchar(100) DEFAULT NULL,
  `foul_type` varchar(100) DEFAULT NULL,
  `fouler_id` varchar(100) DEFAULT NULL,
  `recipient_type` varchar(100) DEFAULT NULL,
  `recipient_id` int DEFAULT NULL,
  `comment` varchar(512) DEFAULT NULL
);

CREATE TABLE `waterpolo_action_penalties` (
  `id` int NOT NULL,
  `event_state_id` int NOT NULL,
  `penalty_type` varchar(100) DEFAULT NULL,
  `penalty_level` varchar(100) DEFAULT NULL,
  `caution_level` varchar(100) DEFAULT NULL,
  `recipient_type` varchar(100) DEFAULT NULL,
  `recipient_id` int DEFAULT NULL,
  `comment` varchar(512) DEFAULT NULL
);

CREATE TABLE `waterpolo_defensive_stats` (
  `id` int NOT NULL,
  `steals` int DEFAULT NULL,
  `saves` int DEFAULT NULL,
  `failed_blocks` int DEFAULT NULL,
  `successful_passes` int DEFAULT NULL
);

CREATE TABLE `waterpolo_event_states` (
  `id` int NOT NULL,
  `event_id` int NOT NULL,
  `current_state` int DEFAULT NULL,
  `period_value` varchar(100) DEFAULT NULL,
  `period_time_elapsed` varchar(100) DEFAULT NULL,
  `period_time_remaining` varchar(100) DEFAULT NULL,
  `home_team_score` tinyint NOT NULL DEFAULT '0',
  `away_team_score` tinyint NOT NULL DEFAULT '0',
  `total_time_remaining` varchar(100) DEFAULT NULL,
  `total_time_elapsed` varchar(100) DEFAULT NULL
);

CREATE TABLE `waterpolo_offensive_stats` (
  `id` int NOT NULL,
  `assists` int DEFAULT NULL,
  `passes_made` int DEFAULT NULL,
  `successful_passes` int DEFAULT NULL,
  `sprints` int DEFAULT NULL,
  `sprints_won` int DEFAULT NULL,
  `goals` int DEFAULT NULL,
  `shots_on_goal` int DEFAULT NULL,
  `shots_on_goal_missed` int DEFAULT NULL,
  `steals` int DEFAULT NULL
);

/*============================================================================*/
/* WATERPOLO CONSTRAINTS                                                      */
/*============================================================================*/

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `waterpolo_action_fouls`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `waterpolo_action_penalties`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `waterpolo_defensive_stats`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `waterpolo_event_states`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `waterpolo_offensive_stats`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `waterpolo_action_fouls`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `waterpolo_action_penalties`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `waterpolo_event_states`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `waterpolo_action_fouls`
  ADD CONSTRAINT `FK_action_fouls` FOREIGN KEY (`event_state_id`) REFERENCES `waterpolo_event_states` (`id`);

ALTER TABLE `waterpolo_action_penalties`
  ADD CONSTRAINT `FK_action_penalties` FOREIGN KEY (`event_state_id`) REFERENCES `waterpolo_event_states` (`id`);

ALTER TABLE `waterpolo_event_states`
  ADD CONSTRAINT `FK_event_states` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`);
