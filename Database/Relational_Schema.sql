CREATE TABLE users (
	id int(11) NOT NULL AUTO_INCREMENT;,
	email varchar(100) NOT NULL,
	username varchar(50) NOT NULL,
	password varchar(100) NOT NULL,
	apiKey varchar(32) DEFAULT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY email (email);
) 
 
CREATE TABLE waterpolo_action_fouls (
	id int(11) NOT NULL AUTO_INCREMENT,
	event_state_id int(11) NOT NULL,
	foul_name varchar(100) DEFAULT NULL,
	foul_result varchar(100) DEFAULT NULL,
	foul_type varchar(100) DEFAULT NULL,
	fouler_id varchar(100) DEFAULT NULL,
	recipient_type varchar(100) DEFAULT NULL,
	recipient_id int(11) DEFAULT NULL,
	comment varchar(512) DEFAULT NULL,
	PRIMARY KEY (id),
	KEY FK_action_fouls (event_state_id),
	FOREIGN KEY (event_state_id) REFERENCES waterpolo_event_states (id);
) 

CREATE TABLE waterpolo_action_penalties (
	id int(11) NOT NULL,
	event_state_id int(11) NOT NULL AUTO_INCREMENT,
	penalty_type varchar(100) DEFAULT NULL,
	penalty_level varchar(100) DEFAULT NULL,
	caution_level varchar(100) DEFAULT NULL,
	recipient_type varchar(100) DEFAULT NULL,
	recipient_id int(11) DEFAULT NULL,
	comment varchar(512) DEFAULT NULL
	KEY FK_action_penalties (event_state_id),
	PRIMARY KEY (id),
	FOREIGN KEY (event_state_id) REFERENCES waterpolo_event_states (id);

) 
 
CREATE TABLE waterpolo_defensive_stats (
	id int(11) NOT NULL,
	steals int(11) NOT NULL DEFAULT 0,
	saves int(11) NOT NULL DEFAULT 0,
	failed_blocks int(11) NOT NULL DEFAULT 0,
	successful_blocks int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (id);
) 

CREATE TABLE waterpolo_event_states (
	id int(11) NOT NULL,
	event_id int(11) NOT NULL AUTO_INCREMENT,
	current_state int(11) DEFAULT NULL,
	period_value varchar(100) DEFAULT NULL,
	period_time_elapsed varchar(100) DEFAULT NULL,
	period_time_remaining varchar(100) DEFAULT NULL,
	home_team_score tinyint(4) NOT NULL DEFAULT 0,
	away_team_score tinyint(4) NOT NULL DEFAULT 0,
	total_time_remaining varchar(100) DEFAULT NULL,
	total_time_elapsed varchar(100) DEFAULT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (event_id) REFERENCES events (id);
) 
 
CREATE TABLE waterpolo_foul_stats (
	id int(11) NOT NULL AUTO_INCREMENT,
	turnovers int(11) NOT NULL DEFAULT 0,
	exclusions int(11) NOT NULL DEFAULT 0,
	major_fouls int(11) NOT NULL DEFAULT 0,
	minor_fouls int(11) NOT NULL DEFAULT 0,
	penalty_shots_taken int(11) NOT NULL DEFAULT 0,
	penalty_shots_given int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (id);
) 

CREATE TABLE waterpolo_offensive_stats (
	id int(11) NOT NULL AUTO_INCREMENT,
	assists int(11) NOT NULL DEFAULT 0,
	successful_passes int(11) NOT NULL DEFAULT 0,
	unsuccessful_passes int(11) NOT NULL DEFAULT 0,
	sprints_won int(11) NOT NULL DEFAULT 0,
	sprints_lost int(11) NOT NULL DEFAULT 0,
	goals int(11) NOT NULL DEFAULT 0,
	misses int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (id);
) 
