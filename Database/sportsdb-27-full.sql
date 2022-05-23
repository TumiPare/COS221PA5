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
/* Tables                                                                     */
/*============================================================================*/
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

CREATE TABLE addresses (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    language VARCHAR(100),
    suite VARCHAR(100),
    floor VARCHAR(100),
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

CREATE TABLE publishers (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    publisher_key VARCHAR(100) NOT NULL,
    publisher_name VARCHAR(100)
);

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

CREATE TABLE affiliations_documents (
    affiliation_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

CREATE TABLE sites (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    site_key VARCHAR(128) NOT NULL,
    publisher_id INTEGER NOT NULL,
    location_id INTEGER
);

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

/*
COMMENT ON COLUMN events.start_date_time
Normalized to UTC
*/

CREATE TABLE affiliations_events (
    affiliation_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL
);

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

CREATE TABLE media (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    object_id INTEGER,
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

CREATE TABLE teams (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    team_key VARCHAR(100) NOT NULL,
    publisher_id INTEGER NOT NULL,
    home_site_id INTEGER
);

CREATE TABLE american_football_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state SMALLINT,
    sequence_number INTEGER,
    period_value INTEGER,
    period_time_elapsed VARCHAR(100),
    period_time_remaining VARCHAR(100),
    clock_state VARCHAR(100),
    down INTEGER,
    team_in_possession_id INTEGER,
    score_team INTEGER,
    score_team_opposing INTEGER,
    distance_for_1st_down INTEGER,
    field_side VARCHAR(100),
    field_line INTEGER,
    context VARCHAR(40),
    score_team_away INTEGER,
    score_team_home INTEGER,
    document_id INTEGER
);

/*
COMMENT ON COLUMN american_football_event_states.field_side
home | away
*/

CREATE TABLE american_football_action_plays (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    american_football_event_state_id INTEGER NOT NULL,
    team_id INTEGER,
    play_type VARCHAR(100),
    score_attempt_type VARCHAR(100),
    touchdown_type VARCHAR(100),
    drive_result VARCHAR(100),
    points INTEGER,
    comment VARCHAR(512)
);

CREATE TABLE american_football_action_participants (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    american_football_action_play_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    participant_role VARCHAR(100) NOT NULL,
    score_type VARCHAR(100),
    field_line INTEGER,
    yardage INTEGER,
    score_credit INTEGER,
    yards_gained INTEGER
);

/*
COMMENT ON COLUMN american_football_action_participants.person_id
Unique per person_key + publisher_id
*/

CREATE TABLE american_football_defensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    tackles_total VARCHAR(100),
    tackles_solo VARCHAR(100),
    tackles_assists VARCHAR(100),
    interceptions_total VARCHAR(100),
    interceptions_yards VARCHAR(100),
    interceptions_average VARCHAR(100),
    interceptions_longest VARCHAR(100),
    interceptions_touchdown VARCHAR(100),
    quarterback_hurries VARCHAR(100),
    sacks_total VARCHAR(100),
    sacks_yards VARCHAR(100),
    passes_defensed VARCHAR(100),
    first_downs_against_total INTEGER,
    first_downs_against_rushing INTEGER,
    first_downs_against_passing INTEGER,
    first_downs_against_penalty INTEGER,
    conversions_third_down_against INTEGER,
    conversions_third_down_against_attempts INTEGER,
    conversions_third_down_against_percentage DECIMAL(5,2),
    conversions_fourth_down_against INTEGER,
    conversions_fourth_down_against_attempts INTEGER,
    conversions_fourth_down_against_percentage DECIMAL(5,2),
    two_point_conversions_against INTEGER,
    two_point_conversions_against_attempts INTEGER,
    offensive_plays_against_touchdown INTEGER,
    offensive_plays_against_average_yards_per_game DECIMAL(5,2),
    rushes_against_attempts INTEGER,
    rushes_against_yards INTEGER,
    rushing_against_average_yards_per_game DECIMAL(5,2),
    rushes_against_touchdowns INTEGER,
    rushes_against_average_yards_per DECIMAL(5,2),
    rushes_against_longest INTEGER,
    receptions_against_total INTEGER,
    receptions_against_yards INTEGER,
    receptions_against_touchdowns INTEGER,
    receptions_against_average_yards_per DECIMAL(5,2),
    receptions_against_longest INTEGER,
    passes_against_yards_net INTEGER,
    passes_against_yards_gross INTEGER,
    passes_against_attempts INTEGER,
    passes_against_completions INTEGER,
    passes_against_percentage DECIMAL(5,2),
    passes_against_average_yards_per_game DECIMAL(5,2),
    passes_against_average_yards_per DECIMAL(5,2),
    passes_against_touchdowns INTEGER,
    passes_against_touchdowns_percentage DECIMAL(5,2),
    passes_against_longest INTEGER,
    passes_against_rating DECIMAL(5,2),
    interceptions_percentage DECIMAL(5,2)
);

CREATE TABLE american_football_down_progress_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_downs_total VARCHAR(100),
    first_downs_pass VARCHAR(100),
    first_downs_run VARCHAR(100),
    first_downs_penalty VARCHAR(100),
    conversions_third_down VARCHAR(100),
    conversions_third_down_attempts VARCHAR(100),
    conversions_third_down_percentage VARCHAR(100),
    conversions_fourth_down VARCHAR(100),
    conversions_fourth_down_attempts VARCHAR(100),
    conversions_fourth_down_percentage VARCHAR(100)
);

CREATE TABLE american_football_fumbles_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    fumbles_committed VARCHAR(100),
    fumbles_forced VARCHAR(100),
    fumbles_recovered VARCHAR(100),
    fumbles_lost VARCHAR(100),
    fumbles_yards_gained VARCHAR(100),
    fumbles_own_committed VARCHAR(100),
    fumbles_own_recovered VARCHAR(100),
    fumbles_own_lost VARCHAR(100),
    fumbles_own_yards_gained VARCHAR(100),
    fumbles_opposing_committed VARCHAR(100),
    fumbles_opposing_recovered VARCHAR(100),
    fumbles_opposing_lost VARCHAR(100),
    fumbles_opposing_yards_gained VARCHAR(100),
    fumbles_own_touchdowns INTEGER,
    fumbles_opposing_touchdowns INTEGER,
    fumbles_committed_defense INTEGER,
    fumbles_committed_special_teams INTEGER,
    fumbles_committed_other INTEGER,
    fumbles_lost_defense INTEGER,
    fumbles_lost_special_teams INTEGER,
    fumbles_lost_other INTEGER,
    fumbles_forced_defense INTEGER,
    fumbles_recovered_defense INTEGER,
    fumbles_recovered_special_teams INTEGER,
    fumbles_recovered_other INTEGER,
    fumbles_recovered_yards_defense INTEGER,
    fumbles_recovered_yards_special_teams INTEGER,
    fumbles_recovered_yards_other INTEGER
);

CREATE TABLE american_football_offensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    offensive_plays_yards VARCHAR(100),
    offensive_plays_number VARCHAR(100),
    offensive_plays_average_yards_per VARCHAR(100),
    possession_duration VARCHAR(100),
    turnovers_giveaway VARCHAR(100),
    tackles INTEGER,
    tackles_assists INTEGER
);

CREATE TABLE american_football_passing_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    passes_attempts VARCHAR(100),
    passes_completions VARCHAR(100),
    passes_percentage VARCHAR(100),
    passes_yards_gross VARCHAR(100),
    passes_yards_net VARCHAR(100),
    passes_yards_lost VARCHAR(100),
    passes_touchdowns VARCHAR(100),
    passes_touchdowns_percentage VARCHAR(100),
    passes_interceptions VARCHAR(100),
    passes_interceptions_percentage VARCHAR(100),
    passes_longest VARCHAR(100),
    passes_average_yards_per VARCHAR(100),
    passer_rating VARCHAR(100),
    receptions_total VARCHAR(100),
    receptions_yards VARCHAR(100),
    receptions_touchdowns VARCHAR(100),
    receptions_first_down VARCHAR(100),
    receptions_longest VARCHAR(100),
    receptions_average_yards_per VARCHAR(100)
);

CREATE TABLE american_football_penalties_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    penalties_total VARCHAR(100),
    penalty_yards VARCHAR(100),
    penalty_first_downs VARCHAR(100)
);

CREATE TABLE american_football_rushing_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    rushes_attempts VARCHAR(100),
    rushes_yards VARCHAR(100),
    rushes_touchdowns VARCHAR(100),
    rushing_average_yards_per VARCHAR(100),
    rushes_first_down VARCHAR(100),
    rushes_longest VARCHAR(100)
);

CREATE TABLE american_football_sacks_against_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sacks_against_yards VARCHAR(100),
    sacks_against_total VARCHAR(100)
);

CREATE TABLE american_football_scoring_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    touchdowns_total VARCHAR(100),
    touchdowns_passing VARCHAR(100),
    touchdowns_rushing VARCHAR(100),
    touchdowns_special_teams VARCHAR(100),
    touchdowns_defensive VARCHAR(100),
    extra_points_attempts VARCHAR(100),
    extra_points_made VARCHAR(100),
    extra_points_missed VARCHAR(100),
    extra_points_blocked VARCHAR(100),
    field_goal_attempts VARCHAR(100),
    field_goals_made VARCHAR(100),
    field_goals_missed VARCHAR(100),
    field_goals_blocked VARCHAR(100),
    safeties_against VARCHAR(100),
    two_point_conversions_attempts VARCHAR(100),
    two_point_conversions_made VARCHAR(100),
    touchbacks_total VARCHAR(100),
    safeties_against_opponent INTEGER
);

CREATE TABLE american_football_special_teams_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    returns_punt_total VARCHAR(100),
    returns_punt_yards VARCHAR(100),
    returns_punt_average VARCHAR(100),
    returns_punt_longest VARCHAR(100),
    returns_punt_touchdown VARCHAR(100),
    returns_kickoff_total VARCHAR(100),
    returns_kickoff_yards VARCHAR(100),
    returns_kickoff_average VARCHAR(100),
    returns_kickoff_longest VARCHAR(100),
    returns_kickoff_touchdown VARCHAR(100),
    returns_total VARCHAR(100),
    returns_yards VARCHAR(100),
    punts_total VARCHAR(100),
    punts_yards_gross VARCHAR(100),
    punts_yards_net VARCHAR(100),
    punts_longest VARCHAR(100),
    punts_inside_20 VARCHAR(100),
    punts_inside_20_percentage VARCHAR(100),
    punts_average VARCHAR(100),
    punts_blocked VARCHAR(100),
    touchbacks_total VARCHAR(100),
    touchbacks_total_percentage VARCHAR(100),
    touchbacks_kickoffs VARCHAR(100),
    touchbacks_kickoffs_percentage VARCHAR(100),
    touchbacks_punts VARCHAR(100),
    touchbacks_punts_percentage VARCHAR(100),
    touchbacks_interceptions VARCHAR(100),
    touchbacks_interceptions_percentage VARCHAR(100),
    fair_catches VARCHAR(100),
    punts_against_blocked INTEGER,
    field_goals_against_attempts_1_to_19 INTEGER,
    field_goals_against_made_1_to_19 INTEGER,
    field_goals_against_attempts_20_to_29 INTEGER,
    field_goals_against_made_20_to_29 INTEGER,
    field_goals_against_attempts_30_to_39 INTEGER,
    field_goals_against_made_30_to_39 INTEGER,
    field_goals_against_attempts_40_to_49 INTEGER,
    field_goals_against_made_40_to_49 INTEGER,
    field_goals_against_attempts_50_plus INTEGER,
    field_goals_against_made_50_plus INTEGER,
    field_goals_against_attempts INTEGER,
    extra_points_against_attempts INTEGER,
    tackles INTEGER,
    tackles_assists INTEGER
);

CREATE TABLE american_football_team_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    yards_per_attempt VARCHAR(100),
    average_starting_position VARCHAR(100),
    timeouts VARCHAR(100),
    time_of_possession VARCHAR(100),
    turnover_ratio VARCHAR(100)
);

CREATE TABLE awards (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_type VARCHAR(100) NOT NULL,
    participant_id INTEGER NOT NULL,
    award_type VARCHAR(100),
    name VARCHAR(100),
    total INTEGER,
    rank VARCHAR(100),
    award_value VARCHAR(100),
    currency VARCHAR(100),
    date_coverage_type VARCHAR(100),
    date_coverage_id INTEGER
);

CREATE TABLE baseball_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state SMALLINT,
    sequence_number DECIMAL(4,1),
    at_bat_number INTEGER,
    inning_value INTEGER,
    inning_half VARCHAR(100),
    outs INTEGER,
    balls INTEGER,
    strikes INTEGER,
    runner_on_first_id INTEGER,
    runner_on_second_id INTEGER,
    runner_on_third_id INTEGER,
    runner_on_first SMALLINT,
    runner_on_second SMALLINT,
    runner_on_third SMALLINT,
    runs_this_inning_half INTEGER,
    pitcher_id INTEGER,
    batter_id INTEGER,
    batter_side VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

/*
COMMENT ON COLUMN baseball_event_states.current_state
true if this is the current state of the event
*/

/*
COMMENT ON COLUMN baseball_event_states.sequence_number
the unique serial number for this state
*/

/*
COMMENT ON COLUMN baseball_event_states.at_bat_number
the unique serial number for this at bat
*/

/*
COMMENT ON COLUMN baseball_event_states.inning_half
top | bottom
*/

/*
COMMENT ON COLUMN baseball_event_states.batter_side
left | right
*/

CREATE TABLE baseball_action_plays (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    baseball_event_state_id INTEGER NOT NULL,
    play_type VARCHAR(100),
    out_type VARCHAR(100),
    notation VARCHAR(100),
    notation_yaml TEXT,
    baseball_defensive_group_id INTEGER,
    comment VARCHAR(512),
    runner_on_first_advance VARCHAR(40),
    runner_on_second_advance VARCHAR(40),
    runner_on_third_advance VARCHAR(40),
    outs_recorded INTEGER,
    rbi INTEGER,
    runs_scored INTEGER,
    earned_runs_scored VARCHAR(100)
);

CREATE TABLE baseball_defensive_group (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY
);

CREATE TABLE baseball_action_pitches (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    baseball_action_play_id INTEGER NOT NULL,
    sequence_number DECIMAL(4,1),
    baseball_defensive_group_id INTEGER,
    umpire_call VARCHAR(100),
    pitch_location VARCHAR(100),
    pitch_type VARCHAR(100),
    pitch_velocity INTEGER,
    comment VARCHAR(2048),
    trajectory_coordinates VARCHAR(512),
    trajectory_formula VARCHAR(100),
    ball_type VARCHAR(40),
    strike_type VARCHAR(40),
    strikes INTEGER,
    balls INTEGER
);

/*
COMMENT ON COLUMN baseball_action_pitches.trajectory_coordinates
yaml array of coordinates?
*/

/*
COMMENT ON COLUMN baseball_action_pitches.trajectory_formula
formula describing this path
*/

CREATE TABLE baseball_action_contact_details (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    baseball_action_pitch_id INTEGER NOT NULL,
    location VARCHAR(100),
    strength VARCHAR(100),
    velocity INTEGER,
    comment VARCHAR(512),
    trajectory_coordinates VARCHAR(100),
    trajectory_formula VARCHAR(100)
);

/*
COMMENT ON COLUMN baseball_action_contact_details.strength
hard | soft | grounder | etc.
*/

/*
COMMENT ON COLUMN baseball_action_contact_details.trajectory_coordinates
yaml array of coordinates?
*/

/*
COMMENT ON COLUMN baseball_action_contact_details.trajectory_formula
formula describing this path
*/

CREATE TABLE positions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    affiliation_id INTEGER NOT NULL,
    abbreviation VARCHAR(100) NOT NULL
);

CREATE TABLE baseball_action_substitutions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    baseball_event_state_id INTEGER NOT NULL,
    sequence_number DECIMAL(4,1),
    person_type VARCHAR(100),
    person_original_id INTEGER,
    person_original_position_id INTEGER,
    person_original_lineup_slot INTEGER,
    person_replacing_id INTEGER,
    person_replacing_position_id INTEGER,
    person_replacing_lineup_slot INTEGER,
    substitution_reason VARCHAR(100),
    comment VARCHAR(512)
);

/*
COMMENT ON COLUMN baseball_action_substitutions.person_type
player | associate | official - NOT NEEDED?
*/

CREATE TABLE baseball_defensive_players (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    baseball_defensive_group_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    position_id INTEGER NOT NULL
);

CREATE TABLE baseball_defensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    double_plays INTEGER,
    triple_plays INTEGER,
    putouts INTEGER,
    assists INTEGER,
    errors INTEGER,
    fielding_percentage FLOAT,
    defensive_average FLOAT,
    errors_passed_ball INTEGER,
    errors_catchers_interference INTEGER,
    stolen_bases_average INTEGER,
    stolen_bases_caught INTEGER
);

CREATE TABLE baseball_offensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    average FLOAT,
    runs_scored INTEGER,
    at_bats INTEGER,
    hits INTEGER,
    rbi INTEGER,
    total_bases INTEGER,
    slugging_percentage FLOAT,
    bases_on_balls INTEGER,
    strikeouts INTEGER,
    left_on_base INTEGER,
    left_in_scoring_position INTEGER,
    singles INTEGER,
    doubles INTEGER,
    triples INTEGER,
    home_runs INTEGER,
    grand_slams INTEGER,
    at_bats_per_rbi FLOAT,
    plate_appearances_per_rbi FLOAT,
    at_bats_per_home_run FLOAT,
    plate_appearances_per_home_run FLOAT,
    sac_flies INTEGER,
    sac_bunts INTEGER,
    grounded_into_double_play INTEGER,
    moved_up INTEGER,
    on_base_percentage FLOAT,
    stolen_bases INTEGER,
    stolen_bases_caught INTEGER,
    stolen_bases_average FLOAT,
    hit_by_pitch INTEGER,
    on_base_plus_slugging FLOAT,
    plate_appearances INTEGER,
    hits_extra_base INTEGER,
    pick_offs_against INTEGER,
    sacrifices INTEGER,
    outs_fly INTEGER,
    outs_ground INTEGER,
    reached_base_defensive_interference INTEGER,
    reached_base_error INTEGER,
    reached_base_fielder_choice INTEGER,
    double_plays_against INTEGER,
    triple_plays_against INTEGER,
    strikeouts_looking INTEGER,
    bases_on_balls_intentional INTEGER
);

CREATE TABLE baseball_pitching_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    runs_allowed INTEGER,
    singles_allowed INTEGER,
    doubles_allowed INTEGER,
    triples_allowed INTEGER,
    home_runs_allowed INTEGER,
    innings_pitched VARCHAR(20),
    hits INTEGER,
    earned_runs INTEGER,
    unearned_runs INTEGER,
    bases_on_balls INTEGER,
    bases_on_balls_intentional INTEGER,
    strikeouts INTEGER,
    strikeout_to_bb_ratio FLOAT,
    number_of_pitches INTEGER,
    era FLOAT,
    inherited_runners_scored INTEGER,
    pick_offs INTEGER,
    errors_hit_with_pitch INTEGER,
    errors_wild_pitch INTEGER,
    balks INTEGER,
    wins INTEGER,
    losses INTEGER,
    saves INTEGER,
    shutouts INTEGER,
    games_complete INTEGER,
    games_finished INTEGER,
    winning_percentage FLOAT,
    event_credit VARCHAR(40),
    save_credit VARCHAR(40),
    batters_doubles_against INTEGER,
    batters_triples_against INTEGER,
    outs_recorded INTEGER,
    batters_at_bats_against INTEGER,
    number_of_strikes INTEGER,
    wins_season INTEGER,
    losses_season INTEGER,
    saves_season INTEGER,
    saves_blown_season INTEGER
);

CREATE TABLE basketball_defensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    steals_total VARCHAR(100),
    steals_per_game VARCHAR(100),
    blocks_total VARCHAR(100),
    blocks_per_game VARCHAR(100)
);

CREATE TABLE basketball_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state TINYINT,
    sequence_number INTEGER,
    period_value VARCHAR(100),
    period_time_elapsed VARCHAR(100),
    period_time_remaining VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

CREATE TABLE basketball_offensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    field_goals_made INTEGER,
    field_goals_attempted INTEGER,
    field_goals_percentage VARCHAR(100),
    field_goals_per_game VARCHAR(100),
    field_goals_attempted_per_game VARCHAR(100),
    field_goals_percentage_adjusted VARCHAR(100),
    three_pointers_made INTEGER,
    three_pointers_attempted INTEGER,
    three_pointers_percentage VARCHAR(100),
    three_pointers_per_game VARCHAR(100),
    three_pointers_attempted_per_game VARCHAR(100),
    free_throws_made VARCHAR(100),
    free_throws_attempted VARCHAR(100),
    free_throws_percentage VARCHAR(100),
    free_throws_per_game VARCHAR(100),
    free_throws_attempted_per_game VARCHAR(100),
    points_scored_total VARCHAR(100),
    points_scored_per_game VARCHAR(100),
    assists_total VARCHAR(100),
    assists_per_game VARCHAR(100),
    turnovers_total VARCHAR(100),
    turnovers_per_game VARCHAR(100),
    points_scored_off_turnovers VARCHAR(100),
    points_scored_in_paint VARCHAR(100),
    points_scored_on_second_chance VARCHAR(100),
    points_scored_on_fast_break VARCHAR(100)
);

CREATE TABLE basketball_rebounding_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    rebounds_total VARCHAR(100),
    rebounds_per_game VARCHAR(100),
    rebounds_defensive VARCHAR(100),
    rebounds_offensive VARCHAR(100),
    team_rebounds_total VARCHAR(100),
    team_rebounds_per_game VARCHAR(100),
    team_rebounds_defensive VARCHAR(100),
    team_rebounds_offensive VARCHAR(100)
);

CREATE TABLE basketball_team_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    timeouts_left VARCHAR(100),
    largest_lead VARCHAR(100),
    fouls_total VARCHAR(100),
    turnover_margin VARCHAR(100)
);

CREATE TABLE bookmakers (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    bookmaker_key VARCHAR(100),
    publisher_id INTEGER NOT NULL,
    location_id INTEGER
);

/*
COMMENT ON COLUMN bookmakers.id
Unique per bookmaker_key + event_id + date_time + (team_id | person_id)
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

CREATE TABLE db_info (
    version VARCHAR(100) NOT NULL DEFAULT 16
);

/*
COMMENT ON COLUMN db_info.version
version of this database
*/

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

CREATE TABLE document_fixtures_events (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    document_fixture_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    latest_document_id INTEGER NOT NULL,
    last_update DATETIME
);

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
    rank VARCHAR(100),
    document_id INTEGER NOT NULL,
    headline VARCHAR(100),
    short_headline VARCHAR(100)
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

CREATE TABLE events_documents (
    event_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

CREATE TABLE events_media (
    event_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);

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

CREATE TABLE events_sub_seasons (
    event_id INTEGER NOT NULL,
    sub_season_id INTEGER NOT NULL
);

CREATE TABLE ice_hockey_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    power_play_team_id INTEGER,
    event_id INTEGER NOT NULL,
    current_state TINYINT,
    period_value VARCHAR(100),
    period_time_elapsed VARCHAR(100),
    period_time_remaining VARCHAR(100),
    record_type VARCHAR(40),
    power_play_player_advantage INTEGER,
    score_team INTEGER,
    score_team_opposing INTEGER,
    score_team_home INTEGER,
    score_team_away INTEGER,
    action_key VARCHAR(100),
    sequence_number VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

CREATE TABLE ice_hockey_action_plays (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ice_hockey_event_state_id INTEGER NOT NULL,
    play_key VARCHAR(100),
    play_type VARCHAR(100),
    score_attempt_type VARCHAR(100),
    play_result VARCHAR(100),
    penalty_type VARCHAR(100),
    penalty_length VARCHAR(100),
    penalty_code VARCHAR(100),
    recipient_type VARCHAR(100),
    team_id INTEGER,
    strength VARCHAR(100),
    shootout_shot_order INTEGER,
    goal_order INTEGER,
    shot_type VARCHAR(100),
    shot_distance VARCHAR(100),
    goal_zone VARCHAR(100),
    penalty_time_remaining VARCHAR(40),
    location VARCHAR(40),
    zone VARCHAR(40),
    comment VARCHAR(1024)
);

CREATE TABLE ice_hockey_action_participants (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    team_id INTEGER NOT NULL,
    ice_hockey_action_play_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    participant_role VARCHAR(100),
    point_credit INTEGER,
    goals_cumulative INTEGER,
    assists_cumulative INTEGER
);

CREATE TABLE ice_hockey_defensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    goals_power_play_allowed VARCHAR(100),
    goals_penalty_shot_allowed VARCHAR(100),
    goals_empty_net_allowed VARCHAR(100),
    goals_against_average VARCHAR(100),
    goals_short_handed_allowed VARCHAR(100),
    goals_shootout_allowed VARCHAR(100),
    shots_power_play_allowed VARCHAR(100),
    shots_penalty_shot_allowed VARCHAR(100),
    shots_blocked VARCHAR(100),
    saves VARCHAR(100),
    save_percentage VARCHAR(100),
    penalty_killing_amount VARCHAR(100),
    penalty_killing_percentage VARCHAR(100),
    takeaways VARCHAR(100),
    shutouts VARCHAR(100),
    minutes_penalty_killing VARCHAR(100),
    hits VARCHAR(100),
    shots_shootout_allowed VARCHAR(100),
    goaltender_wins INTEGER,
    goaltender_losses INTEGER,
    goaltender_ties INTEGER,
    goals_allowed INTEGER,
    shots_allowed INTEGER,
    player_count INTEGER,
    player_count_opposing INTEGER,
    goaltender_wins_overtime INTEGER,
    goaltender_losses_overtime INTEGER,
    goals_overtime_allowed INTEGER
);

CREATE TABLE ice_hockey_faceoff_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    player_count INTEGER,
    player_count_opposing INTEGER,
    faceoff_wins INTEGER,
    faceoff_losses INTEGER,
    faceoff_win_percentage DECIMAL(5,2),
    faceoffs_power_play_wins INTEGER,
    faceoffs_power_play_losses INTEGER,
    faceoffs_power_play_win_percentage DECIMAL(5,2),
    faceoffs_short_handed_wins INTEGER,
    faceoffs_short_handed_losses INTEGER,
    faceoffs_short_handed_win_percentage DECIMAL(5,2),
    faceoffs_even_strength_wins INTEGER,
    faceoffs_even_strength_losses INTEGER,
    faceoffs_even_strength_win_percentage DECIMAL(5,2),
    faceoffs_offensive_zone_wins INTEGER,
    faceoffs_offensive_zone_losses INTEGER,
    faceoffs_offensive_zone_win_percentage DECIMAL(5,2),
    faceoffs_defensive_zone_wins INTEGER,
    faceoffs_defensive_zone_losses INTEGER,
    faceoffs_defensive_zone_win_percentage DECIMAL(5,2),
    faceoffs_neutral_zone_wins INTEGER,
    faceoffs_neutral_zone_losses INTEGER,
    faceoffs_neutral_zone_win_percentage DECIMAL(5,2)
);

CREATE TABLE ice_hockey_offensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    giveaways VARCHAR(100),
    goals INTEGER,
    goals_game_winning VARCHAR(100),
    goals_game_tying VARCHAR(100),
    goals_power_play VARCHAR(100),
    goals_short_handed VARCHAR(100),
    goals_even_strength VARCHAR(100),
    goals_empty_net VARCHAR(100),
    goals_overtime VARCHAR(100),
    goals_shootout VARCHAR(100),
    goals_penalty_shot VARCHAR(100),
    assists VARCHAR(100),
    shots INTEGER,
    shots_penalty_shot_taken VARCHAR(100),
    shots_penalty_shot_missed VARCHAR(100),
    shots_penalty_shot_percentage VARCHAR(100),
    shots_missed INTEGER,
    shots_blocked INTEGER,
    shots_power_play INTEGER,
    shots_short_handed INTEGER,
    shots_even_strength INTEGER,
    points VARCHAR(100),
    power_play_amount VARCHAR(100),
    power_play_percentage VARCHAR(100),
    minutes_power_play VARCHAR(100),
    faceoff_wins VARCHAR(100),
    faceoff_losses VARCHAR(100),
    faceoff_win_percentage VARCHAR(100),
    scoring_chances VARCHAR(100),
    player_count INTEGER,
    player_count_opposing INTEGER,
    assists_game_winning INTEGER,
    assists_overtime INTEGER
);

CREATE TABLE ice_hockey_player_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    plus_minus VARCHAR(100)
);

CREATE TABLE ice_hockey_time_on_ice_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    player_count INTEGER,
    player_count_opposing INTEGER,
    shifts INTEGER,
    time_total VARCHAR(40),
    time_power_play VARCHAR(40),
    time_short_handed VARCHAR(40),
    time_even_strength VARCHAR(40),
    time_empty_net VARCHAR(40),
    time_power_play_empty_net VARCHAR(40),
    time_short_handed_empty_net VARCHAR(40),
    time_even_strength_empty_net VARCHAR(40),
    time_average_per_shift VARCHAR(40)
);

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

CREATE TABLE latest_revisions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    revision_id VARCHAR(255) NOT NULL,
    latest_document_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN latest_revisions.revision_id
a string from the SportsML
*/

CREATE TABLE media_contents (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    media_id INTEGER NOT NULL,
    object VARCHAR(100),
    format VARCHAR(100),
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

CREATE TABLE motor_racing_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state TINYINT,
    sequence_number INTEGER,
    lap VARCHAR(100),
    laps_remaining VARCHAR(100),
    time_elapsed VARCHAR(100),
    flag_state VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

CREATE TABLE motor_racing_event_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    speed_average NUMERIC(6,3),
    speed_units VARCHAR(40),
    margin_of_victory NUMERIC(6,3),
    caution_flags INTEGER,
    caution_flags_laps INTEGER,
    lead_changes INTEGER,
    lead_changes_drivers INTEGER,
    laps_total INTEGER
);

CREATE TABLE motor_racing_qualifying_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    grid VARCHAR(100),
    pole_position VARCHAR(100),
    pole_wins VARCHAR(100),
    qualifying_speed VARCHAR(100),
    qualifying_speed_units VARCHAR(100),
    qualifying_time VARCHAR(100),
    qualifying_position VARCHAR(100)
);

CREATE TABLE motor_racing_race_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    time_behind_leader VARCHAR(100),
    laps_behind_leader VARCHAR(100),
    time_ahead_follower VARCHAR(100),
    laps_ahead_follower VARCHAR(100),
    time VARCHAR(100),
    points VARCHAR(100),
    points_rookie VARCHAR(100),
    bonus VARCHAR(100),
    laps_completed VARCHAR(100),
    laps_leading_total VARCHAR(100),
    distance_leading VARCHAR(100),
    distance_completed VARCHAR(100),
    distance_units VARCHAR(40),
    speed_average VARCHAR(40),
    speed_units VARCHAR(40),
    status VARCHAR(40),
    finishes_top_5 VARCHAR(40),
    finishes_top_10 VARCHAR(40),
    starts VARCHAR(40),
    finishes VARCHAR(40),
    non_finishes VARCHAR(40),
    wins VARCHAR(40),
    races_leading VARCHAR(40),
    money VARCHAR(40),
    money_units VARCHAR(40),
    leads_total VARCHAR(40)
);

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
    rank VARCHAR(100),
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

CREATE TABLE participants_events (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_type VARCHAR(100) NOT NULL,
    participant_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    alignment VARCHAR(100),
    score VARCHAR(100),
    event_outcome VARCHAR(100),
    rank INTEGER,
    result_effect VARCHAR(100),
    score_attempts INTEGER,
    sort_order VARCHAR(100),
    score_type VARCHAR(100)
);

CREATE TABLE penalty_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    count INTEGER,
    type VARCHAR(100),
    value INTEGER
);

CREATE TABLE periods (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    participant_event_id INTEGER NOT NULL,
    period_value VARCHAR(100),
    score VARCHAR(100),
    score_attempts INTEGER,
    rank VARCHAR(100),
    sub_score_key VARCHAR(100),
    sub_score_type VARCHAR(100),
    sub_score_name VARCHAR(100)
);

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

CREATE TABLE persons_documents (
    person_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

CREATE TABLE persons_media (
    person_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);

/*
COMMENT ON COLUMN persons_media.person_id
Unique per person_key + publisher_id
*/

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

CREATE TABLE soccer_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state TINYINT,
    sequence_number INTEGER,
    period_value VARCHAR(100),
    period_time_elapsed VARCHAR(100),
    period_time_remaining VARCHAR(100),
    minutes_elapsed VARCHAR(100),
    period_minute_elapsed VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

CREATE TABLE soccer_action_fouls (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    soccer_event_state_id INTEGER NOT NULL,
    foul_name VARCHAR(100),
    foul_result VARCHAR(100),
    foul_type VARCHAR(100),
    fouler_id VARCHAR(100),
    recipient_type VARCHAR(100),
    recipient_id INTEGER NOT NULL,
    comment VARCHAR(512)
);

CREATE TABLE soccer_action_plays (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    soccer_event_state_id INTEGER NOT NULL,
    play_type VARCHAR(100),
    score_attempt_type VARCHAR(100),
    play_result VARCHAR(100),
    comment VARCHAR(100)
);

CREATE TABLE soccer_action_participants (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    soccer_action_play_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    participant_role VARCHAR(100)
);

CREATE TABLE soccer_action_penalties (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    soccer_event_state_id INTEGER NOT NULL,
    penalty_type VARCHAR(100),
    penalty_level VARCHAR(100),
    caution_value VARCHAR(100),
    recipient_type VARCHAR(100),
    recipient_id INTEGER NOT NULL,
    comment VARCHAR(512)
);

CREATE TABLE soccer_action_substitutions (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    soccer_event_state_id INTEGER NOT NULL,
    person_type VARCHAR(100),
    person_original_id INTEGER NOT NULL,
    person_original_position_id INTEGER,
    person_replacing_id INTEGER NOT NULL,
    person_replacing_position_id INTEGER,
    substitution_reason VARCHAR(100),
    comment VARCHAR(512)
);

CREATE TABLE soccer_defensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    shots_penalty_shot_allowed VARCHAR(100),
    goals_penalty_shot_allowed VARCHAR(100),
    goals_against_average VARCHAR(100),
    goals_against_total VARCHAR(100),
    saves VARCHAR(100),
    save_percentage VARCHAR(100),
    catches_punches VARCHAR(100),
    shots_on_goal_total VARCHAR(100),
    shots_shootout_total VARCHAR(100),
    shots_shootout_allowed VARCHAR(100),
    shots_blocked VARCHAR(100),
    shutouts VARCHAR(100)
);

CREATE TABLE soccer_foul_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    fouls_suffered VARCHAR(100),
    fouls_commited VARCHAR(100),
    cautions_total VARCHAR(100),
    cautions_pending VARCHAR(100),
    caution_points_total VARCHAR(100),
    caution_points_pending VARCHAR(100),
    ejections_total VARCHAR(100)
);

CREATE TABLE soccer_offensive_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    goals_game_winning VARCHAR(100),
    goals_game_tying VARCHAR(100),
    goals_overtime VARCHAR(100),
    goals_shootout VARCHAR(100),
    goals_total VARCHAR(100),
    assists_game_winning VARCHAR(100),
    assists_game_tying VARCHAR(100),
    assists_overtime VARCHAR(100),
    assists_total VARCHAR(100),
    points VARCHAR(100),
    shots_total VARCHAR(100),
    shots_on_goal_total VARCHAR(100),
    shots_hit_frame VARCHAR(100),
    shots_penalty_shot_taken VARCHAR(100),
    shots_penalty_shot_scored VARCHAR(100),
    shots_penalty_shot_missed VARCHAR(40),
    shots_penalty_shot_percentage VARCHAR(40),
    shots_shootout_taken VARCHAR(40),
    shots_shootout_scored VARCHAR(40),
    shots_shootout_missed VARCHAR(40),
    shots_shootout_percentage VARCHAR(40),
    giveaways VARCHAR(40),
    offsides VARCHAR(40),
    corner_kicks VARCHAR(40),
    hat_tricks VARCHAR(40)
);

CREATE TABLE sports_property (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sports_property_type VARCHAR(100),
    sports_property_id INTEGER,
    formal_name VARCHAR(100) NOT NULL,
    value VARCHAR(255)
);

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

CREATE TABLE teams_documents (
    team_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL
);

CREATE TABLE teams_media (
    team_id INTEGER NOT NULL,
    media_id INTEGER NOT NULL
);

CREATE TABLE tennis_action_points (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sub_period_id VARCHAR(100),
    sequence_number VARCHAR(100),
    win_type VARCHAR(100)
);

/*
COMMENT ON COLUMN tennis_action_points.win_type
forced | unforced
*/

CREATE TABLE tennis_action_volleys (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sequence_number VARCHAR(100),
    tennis_action_points_id INTEGER,
    landing_location VARCHAR(100),
    swing_type VARCHAR(100),
    result VARCHAR(100),
    spin_type VARCHAR(100),
    trajectory_details VARCHAR(100)
);

/*
COMMENT ON TABLE tennis_action_volleys
One row per time the ball makes contact with a racquet. Including the first serve and the second serve.
*/

/*
COMMENT ON COLUMN tennis_action_volleys.sequence_number
1 == first_service | 2 == second_service | 3 == return | 4 == the_next_volley | etc.
*/

/*
COMMENT ON COLUMN tennis_action_volleys.landing_location
for things like hawkeye coordinates
*/

/*
COMMENT ON COLUMN tennis_action_volleys.swing_type
forward | backhand
*/

/*
COMMENT ON COLUMN tennis_action_volleys.result
winner | out | returned | let
*/

CREATE TABLE tennis_event_states (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    current_state TINYINT,
    sequence_number INTEGER,
    tennis_set VARCHAR(100),
    game VARCHAR(100),
    server_person_id INTEGER,
    server_score VARCHAR(100),
    receiver_person_id INTEGER,
    receiver_score VARCHAR(100),
    service_number VARCHAR(100),
    context VARCHAR(40),
    document_id INTEGER
);

/*
COMMENT ON COLUMN tennis_event_states.tennis_set
set is a reserved word in SQL
*/

CREATE TABLE tennis_player_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    net_points_won INTEGER,
    net_points_played INTEGER,
    points_won INTEGER,
    winners INTEGER,
    unforced_errors INTEGER,
    winners_forehand INTEGER,
    winners_backhand INTEGER,
    winners_volley INTEGER
);

CREATE TABLE tennis_return_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    returns_played INTEGER,
    matches_played INTEGER,
    first_service_return_points_won INTEGER,
    first_service_return_points_won_pct INTEGER,
    second_service_return_points_won INTEGER,
    second_service_return_points_won_pct INTEGER,
    return_games_played INTEGER,
    return_games_won INTEGER,
    return_games_won_pct INTEGER,
    break_points_played INTEGER,
    break_points_converted INTEGER,
    break_points_converted_pct INTEGER,
    net_points_won INTEGER,
    net_points_played INTEGER,
    points_won INTEGER,
    winners INTEGER,
    unforced_errors INTEGER,
    winners_forehand INTEGER,
    winners_backhand INTEGER,
    winners_volley INTEGER
);

CREATE TABLE tennis_service_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    services_played INTEGER,
    matches_played INTEGER,
    aces INTEGER,
    first_services_good INTEGER,
    first_services_good_pct INTEGER,
    first_service_points_won INTEGER,
    first_service_points_won_pct INTEGER,
    second_service_points_won INTEGER,
    second_service_points_won_pct INTEGER,
    service_games_played INTEGER,
    service_games_won INTEGER,
    service_games_won_pct INTEGER,
    break_points_played INTEGER,
    break_points_saved INTEGER,
    break_points_saved_pct INTEGER,
    service_points_won INTEGER,
    service_points_won_pct INTEGER,
    double_faults INTEGER,
    first_service_top_speed VARCHAR(100),
    second_services_good INTEGER,
    second_services_good_pct INTEGER,
    second_service_top_speed VARCHAR(100),
    net_points_won INTEGER,
    net_points_played INTEGER,
    points_won INTEGER,
    winners INTEGER,
    unforced_errors INTEGER,
    winners_forehand INTEGER,
    winners_backhand INTEGER,
    winners_volley INTEGER
);

CREATE TABLE tennis_set_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    net_points_won INTEGER,
    net_points_played INTEGER,
    points_won INTEGER,
    winners INTEGER,
    unforced_errors INTEGER,
    winners_forehand INTEGER,
    winners_backhand INTEGER,
    winners_volley INTEGER
);

CREATE TABLE tennis_team_stats (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    net_points_won INTEGER,
    net_points_played INTEGER,
    points_won INTEGER,
    winners INTEGER,
    unforced_errors INTEGER,
    winners_forehand INTEGER,
    winners_backhand INTEGER,
    winners_volley INTEGER
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
    line VARCHAR(100),
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

/*============================================================================*/
/* Foreign keys                                                               */
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

ALTER TABLE american_football_event_states
    ADD CONSTRAINT FK_ame_foo_eve_sta_tea_in_pos_id__tea_id
    FOREIGN KEY (team_in_possession_id) REFERENCES teams (id);

ALTER TABLE american_football_event_states
    ADD CONSTRAINT FK_ame_foo_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE american_football_action_plays
    ADD CONSTRAINT FK_ame_foo_act_pla_ame_foo_eve_sta_id__ame_foo_eve_sta_id
    FOREIGN KEY (american_football_event_state_id) REFERENCES american_football_event_states (id);

ALTER TABLE american_football_action_plays
    ADD CONSTRAINT FK_american_football_action_plays_team_id_teams_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE american_football_action_participants
    ADD CONSTRAINT FK_ame_foo_act_par_per_id__per_id
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE american_football_action_participants
    ADD CONSTRAINT FK_ame_foo_act_par_ame_foo_act_pla_id__ame_foo_act_pla_id
    FOREIGN KEY (american_football_action_play_id) REFERENCES american_football_action_plays (id);

ALTER TABLE baseball_event_states
    ADD CONSTRAINT FK_bas_eve_sta_run_on_sec_id__per_id
    FOREIGN KEY (runner_on_second_id) REFERENCES persons (id);

ALTER TABLE baseball_event_states
    ADD CONSTRAINT FK_bas_eve_sta_run_on_thi_id__per_id
    FOREIGN KEY (runner_on_third_id) REFERENCES persons (id);

ALTER TABLE baseball_event_states
    ADD CONSTRAINT FK_bas_eve_sta_run_on_fir_id__per_id
    FOREIGN KEY (runner_on_first_id) REFERENCES persons (id);

ALTER TABLE baseball_event_states
    ADD CONSTRAINT FK_bas_eve_sta_bat_id__per_id
    FOREIGN KEY (batter_id) REFERENCES persons (id);

ALTER TABLE baseball_event_states
    ADD CONSTRAINT FK_bas_eve_sta_pit_id__per_id
    FOREIGN KEY (pitcher_id) REFERENCES persons (id);

ALTER TABLE baseball_event_states
    ADD CONSTRAINT FK_bas_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE baseball_action_plays
    ADD CONSTRAINT FK_bas_act_pla_bas_eve_sta_id__bas_eve_sta_id
    FOREIGN KEY (baseball_event_state_id) REFERENCES baseball_event_states (id);

ALTER TABLE baseball_action_pitches
    ADD CONSTRAINT FK_baseball_action_plays_baseball_action_pitches
    FOREIGN KEY (baseball_action_play_id) REFERENCES baseball_action_plays (id);

ALTER TABLE baseball_action_pitches
    ADD CONSTRAINT FK_bas_act_pit_bas_def_gro_id__bas_def_gro_id
    FOREIGN KEY (baseball_defensive_group_id) REFERENCES baseball_defensive_group (id);

ALTER TABLE baseball_action_contact_details
    ADD CONSTRAINT FK_bas_act_con_det_bas_act_pit_id__bas_act_pit_id
    FOREIGN KEY (baseball_action_pitch_id) REFERENCES baseball_action_pitches (id);

ALTER TABLE positions
    ADD CONSTRAINT FK_pos_aff_id__aff_id
    FOREIGN KEY (affiliation_id) REFERENCES affiliations (id);

ALTER TABLE baseball_action_substitutions
    ADD CONSTRAINT FK_bas_act_sub_per_rep_pos_id__pos_id
    FOREIGN KEY (person_replacing_position_id) REFERENCES positions (id);

ALTER TABLE baseball_action_substitutions
    ADD CONSTRAINT FK_bas_act_sub_per_ori_pos_id__pos_id
    FOREIGN KEY (person_original_position_id) REFERENCES positions (id);

ALTER TABLE baseball_action_substitutions
    ADD CONSTRAINT FK_bas_act_sub_bas_eve_sta_id__bas_eve_sta_id
    FOREIGN KEY (baseball_event_state_id) REFERENCES baseball_event_states (id);

ALTER TABLE baseball_action_substitutions
    ADD CONSTRAINT FK_bas_act_sub_per_rep_id__per_id
    FOREIGN KEY (person_replacing_id) REFERENCES persons (id);

ALTER TABLE baseball_action_substitutions
    ADD CONSTRAINT FK_bas_act_sub_per_ori_id__per_id
    FOREIGN KEY (person_original_id) REFERENCES persons (id);

ALTER TABLE baseball_defensive_players
    ADD CONSTRAINT FK_bas_def_pla_bas_def_gro_id__bas_def_gro_id
    FOREIGN KEY (baseball_defensive_group_id) REFERENCES baseball_defensive_group (id);

ALTER TABLE baseball_defensive_players
    ADD CONSTRAINT FK_bas_def_pla_pla_id__per_id
    FOREIGN KEY (player_id) REFERENCES persons (id);

ALTER TABLE baseball_defensive_players
    ADD CONSTRAINT FK_bas_def_pla_pos_id__pos_id
    FOREIGN KEY (position_id) REFERENCES positions (id);

ALTER TABLE basketball_event_states
    ADD CONSTRAINT FK_bask_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

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

ALTER TABLE ice_hockey_event_states
    ADD CONSTRAINT FK_ice_hoc_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE ice_hockey_event_states
    ADD CONSTRAINT FK_hockey_event_states_power_play_team_id_teams_id
    FOREIGN KEY (power_play_team_id) REFERENCES teams (id);

ALTER TABLE ice_hockey_action_plays
    ADD CONSTRAINT FK_ice_hockey_event_states_ice_hockey_action_plays
    FOREIGN KEY (ice_hockey_event_state_id) REFERENCES ice_hockey_event_states (id);

ALTER TABLE ice_hockey_action_participants
    ADD CONSTRAINT FK_ice_hockey_action_participants_team_id_teams_id
    FOREIGN KEY (team_id) REFERENCES teams (id);

ALTER TABLE ice_hockey_action_participants
    ADD CONSTRAINT FK_persons_ice_hockey_action_participants
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE ice_hockey_action_participants
    ADD CONSTRAINT FK_ice_hockey_action_plays_ice_hockey_action_participants
    FOREIGN KEY (ice_hockey_action_play_id) REFERENCES ice_hockey_action_plays (id);

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

ALTER TABLE motor_racing_event_states
    ADD CONSTRAINT FK_mot_rac_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

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

ALTER TABLE soccer_event_states
    ADD CONSTRAINT FK_soc_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE soccer_action_fouls
    ADD CONSTRAINT FK_soccer_event_states_soccer_action_fouls
    FOREIGN KEY (soccer_event_state_id) REFERENCES soccer_event_states (id);

ALTER TABLE soccer_action_fouls
    ADD CONSTRAINT FK_persons_soccer_action_fouls
    FOREIGN KEY (recipient_id) REFERENCES persons (id);

ALTER TABLE soccer_action_plays
    ADD CONSTRAINT FK_soccer_event_states_soccer_action_plays
    FOREIGN KEY (soccer_event_state_id) REFERENCES soccer_event_states (id);

ALTER TABLE soccer_action_participants
    ADD CONSTRAINT FK_soccer_action_plays_soccer_action_participants
    FOREIGN KEY (soccer_action_play_id) REFERENCES soccer_action_plays (id);

ALTER TABLE soccer_action_participants
    ADD CONSTRAINT FK_persons_soccer_action_participants
    FOREIGN KEY (person_id) REFERENCES persons (id);

ALTER TABLE soccer_action_penalties
    ADD CONSTRAINT FK_soccer_event_states_soccer_action_penalties
    FOREIGN KEY (soccer_event_state_id) REFERENCES soccer_event_states (id);

ALTER TABLE soccer_action_penalties
    ADD CONSTRAINT FK_persons_soccer_action_penalties
    FOREIGN KEY (recipient_id) REFERENCES persons (id);

ALTER TABLE soccer_action_substitutions
    ADD CONSTRAINT FK_soccer_event_states_soccer_action_substitutions
    FOREIGN KEY (soccer_event_state_id) REFERENCES soccer_event_states (id);

ALTER TABLE soccer_action_substitutions
    ADD CONSTRAINT FK_persons_soccer_action_substitutions
    FOREIGN KEY (person_original_id) REFERENCES persons (id);

ALTER TABLE soccer_action_substitutions
    ADD CONSTRAINT FK_persons_soccer_action_substitutions1
    FOREIGN KEY (person_replacing_id) REFERENCES persons (id);

ALTER TABLE soccer_action_substitutions
    ADD CONSTRAINT FK_positions_soccer_action_substitutions
    FOREIGN KEY (person_original_position_id) REFERENCES positions (id);

ALTER TABLE soccer_action_substitutions
    ADD CONSTRAINT FK_positions_soccer_action_substitutions1
    FOREIGN KEY (person_replacing_position_id) REFERENCES positions (id);

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

ALTER TABLE tennis_event_states
    ADD CONSTRAINT FK_ten_eve_sta_eve_id__eve_id
    FOREIGN KEY (event_id) REFERENCES events (id);

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
/* Indexes                                                                    */
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

ALTER TABLE american_football_event_states
ADD INDEX IDX_american_football_event_states_1 (current_state);

ALTER TABLE american_football_event_states
ADD INDEX IDX_american_football_event_states_context (context);

ALTER TABLE american_football_event_states
ADD INDEX IDX_american_football_event_states_seq_num (sequence_number);

ALTER TABLE american_football_event_states
ADD INDEX IDX_FK_ame_foo_eve_sta_eve_id__eve_id (event_id);

ALTER TABLE american_football_action_plays
ADD INDEX IDX_american_football_action_plays_1 (play_type);

ALTER TABLE american_football_action_plays
ADD INDEX IDX_american_football_action_plays_2 (score_attempt_type);

ALTER TABLE american_football_action_plays
ADD INDEX IDX_american_football_action_plays_3 (drive_result);

ALTER TABLE american_football_action_plays
ADD INDEX IDX_FK_ame_foo_act_pla_ame_foo_eve_sta_id__ame_foo_eve_sta_id (american_football_event_state_id);

ALTER TABLE american_football_action_participants
ADD INDEX IDX_american_football_action_participants_1 (participant_role);

ALTER TABLE american_football_action_participants
ADD INDEX IDX_american_football_action_participants_2 (score_type);

ALTER TABLE american_football_action_participants
ADD INDEX IDX_FK_ame_foo_act_par_ame_foo_act_pla_id__ame_foo_act_pla_id (american_football_action_play_id);

ALTER TABLE american_football_action_participants
ADD INDEX IDX_FK_ame_foo_act_par_per_id__per_id (person_id);

ALTER TABLE baseball_event_states
ADD INDEX IDX_baseball_event_states_1 (current_state);

ALTER TABLE baseball_event_states
ADD INDEX IDX_baseball_event_states_context (context);

ALTER TABLE baseball_event_states
ADD INDEX IDX_baseball_event_states_seq_num (sequence_number);

ALTER TABLE baseball_event_states
ADD INDEX IDX_FK_bas_eve_sta_eve_id__eve_id (event_id);

ALTER TABLE baseball_action_plays
ADD INDEX IDX_baseball_action_plays_1 (play_type);

ALTER TABLE baseball_action_plays
ADD INDEX IDX_baseball_action_plays_2 (out_type);

ALTER TABLE baseball_action_plays
ADD INDEX IDX_FK_bas_act_pla_bas_eve_sta_id__bas_eve_sta_id (baseball_event_state_id);

ALTER TABLE baseball_action_pitches
ADD INDEX IDX_baseball_action_pitches_1 (umpire_call);

ALTER TABLE baseball_action_pitches
ADD INDEX IDX_baseball_action_pitches_2 (pitch_type);

ALTER TABLE baseball_action_pitches
ADD INDEX IDX_FK_bas_act_pit_bas_def_gro_id__bas_def_gro_id (baseball_defensive_group_id);

ALTER TABLE positions
ADD INDEX IDX_FK_pos_aff_id__aff_id (affiliation_id);

ALTER TABLE positions
ADD INDEX IDX_positions_1 (abbreviation);

ALTER TABLE basketball_event_states
ADD INDEX IDX_basketball_event_states_context (context);

ALTER TABLE basketball_event_states
ADD INDEX IDX_basketball_event_states_seq_num (sequence_number);

ALTER TABLE basketball_event_states
ADD INDEX IDX_FK_events_basketball_event_states (event_id);

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

ALTER TABLE ice_hockey_event_states
ADD INDEX IDX_ice_hockey_event_states_context (context);

ALTER TABLE ice_hockey_event_states
ADD INDEX IDX_ice_hockey_event_states_seq_num (sequence_number);

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

ALTER TABLE motor_racing_event_states
ADD INDEX IDX_FK_events_motor_racing_event_states (event_id);

ALTER TABLE motor_racing_event_states
ADD INDEX IDX_motor_racing_event_states_context (context);

ALTER TABLE motor_racing_event_states
ADD INDEX IDX_motor_racing_event_states_seq_num (sequence_number);

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

ALTER TABLE soccer_event_states
ADD INDEX IDX_FK_events_soccer_event_states (event_id);

ALTER TABLE soccer_event_states
ADD INDEX IDX_soccer_event_states_context (context);

ALTER TABLE soccer_event_states
ADD INDEX IDX_soccer_event_states_seq_num (sequence_number);

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

ALTER TABLE tennis_event_states
ADD INDEX IDX_FK_events_tennis_event_states (event_id);

ALTER TABLE tennis_event_states
ADD INDEX IDX_tennis_event_states_context (context);

ALTER TABLE tennis_event_states
ADD INDEX IDX_tennis_event_states_seq_num (sequence_number);

ALTER TABLE weather_conditions
ADD INDEX IDX_FK_wea_con_eve_id__eve_id (event_id);

DELETE FROM db_info;
INSERT INTO db_info (version) VALUES ('27');