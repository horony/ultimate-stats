##########################
# general control tables #
##########################

DROP TABLE IF EXISTS xa7580_db2.ct_matchup_params;

CREATE TABLE IF NOT EXISTS xa7580_db2.ct_matchup_params (

	version_nr SMALLINT(1) 
	, version_name VARCHAR(36)
	, treshold_close_match DECIMAL(2,2) comment "treshold value for goal difference making it a close match (e.g. factor 1.15 equals 15-13)" 
	, treshold_contested_match DECIMAL(2,2) comment "treshold value for goal difference making it a contested match (e.g. factor 1.36 equals 15-11)"
	, treshold_clear_match DECIMAL(2,2) comment "treshold value for blowout difference making it a clear match (e.g. factor 2.14 equals 15-7)"
	, treshold_blowout_match DECIMAL(2,2) comment "treshold value for blowout difference making it a blowout match (e.g. factor 5.0 equals 15-3)"

)

COMMENT "Control table to adjust threshold value which define what matches are considered close, blowout etc."
;


###########################
# general dimensiontables #
###########################

# countries

DROP TABLE IF EXISTS xa7580_db2.d_countries;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_countries (

	country_id VARCHAR(3) PRIMARY KEY comment "ioc country code e.g. GER for Germany"
	, name VARCHAR(64) comment "country name"
	, name_display VARCHAR(64) comment "country name to display"
	, image VARCHAR(256) comment "link to country flag"
	, is_real_country SMALLINT(1) NOT NULL DEFAULT 1 comment "e.g. European Islands is not a real country"

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

)

COMMENT "Dimension table for country information"
;

# location

DROP TABLE IF EXISTS xa7580_db2.d_locations;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_locations (

	location_id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY 
	
	, name VARCHAR(256)
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)
	, image VARCHAR(500)

	, location_country_id VARCHAR(3) DEFAULT 'AAA'
	, location_city VARCHAR(64)
	, location_address VARCHAR(256)
	, location_coords POINT
	, location_surfaces VARCHAR(128)
	, website VARCHAR(256) 

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)
)

COMMENT "Dimension table for location information"
;

########################################
# hierarchy ultimate teams:            #
# 1. association -> 2. club -> 3. team #
########################################

# 1. associations

DROP TABLE IF EXISTS xa7580_db2.d_associations;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_associations (

	association_id varchar(16) PRIMARY KEY comment "associations id like WFDF or DFV"

	, name VARCHAR(256)
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)
	, image VARCHAR(500)
	, notes VARCHAR(500)

	, association_type VARCHAR(64) comment "e.g. National, Continental, International"
	, country_id VARCHAR(3) DEFAULT 'AAA'
	, year_founded INTEGER(4) 
	, is_active SMALLINT(1) NOT NULL DEFAULT 1

	, website VARCHAR(256) 
	, insta VARCHAR(256) 
	, meta VARCHAR(256) 
	, twttr VARCHAR(256) 
	, tktk VARCHAR(256) 
	, youtube VARCHAR(256) 

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

    , FOREIGN KEY (country_id) REFERENCES d_countries(country_id)

)

COMMENT "Listing associations like WFDF, IOC, DFV, EUF"
;

# 2. clubs

DROP TABLE IF EXISTS xa7580_db2.d_clubs;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_clubs(

	club_id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY 
	, association_id VARCHAR(10) 

	, name VARCHAR(256)
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)
	, image VARCHAR(500)
	, notes VARCHAR(500)

	, competition VARCHAR(64) comment "e.g. club, nationalteam, college, multiple"
	, country_id VARCHAR(3)
	, year_founded INTEGER(4) 
	, is_active SMALLINT(1) NOT NULL DEFAULT 1

	, website VARCHAR(256) 
	, insta VARCHAR(256) 
	, meta VARCHAR(256) 
	, twttr VARCHAR(256) 
	, tktk VARCHAR(256) 
	, youtube VARCHAR(256) 

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

    , FOREIGN KEY (association_id) REFERENCES d_associations(association_id)
    , FOREIGN KEY (country_id) REFERENCES d_countries(country_id)


)

COMMENT "Main dimension table listing all clubs (e.g. BG Goettingen, Eintrach Frankfurt)"
;

# 3. teams

DROP TABLE IF EXISTS xa7580_db2.d_teams;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_teams (

	team_id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY 
	, club_id BIGINT(20) DEFAULT 0
	, association_id VARCHAR(10) DEFAULT 'AAA'

	, name VARCHAR(256)
	, team_id_str VARCHAR(256) 	
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)
	, image VARCHAR(500)
	, notes VARCHAR(500)
	, achievements VARCHAR(500) comment "e.g. national champion 2012"

	, country_id VARCHAR(3) DEFAULT 'AAA'
	, city VARCHAR(64)
	, year_founded INTEGER(4) 
	, is_active SMALLINT(1) NOT NULL DEFAULT 1 comment "if false team is inactive" 

	, gender_division VARCHAR(32) comment "e.g. mixed, open, etc"
	, age_division VARCHAR(32) comment "e.g. masters, juniors, etc"
	, competition_division VARCHAR(32) comment "e.g. club, nationalteam, college, etc."

	, national_titles INTEGER(3) NOT NULL DEFAULT 0
	, continental_titles INTEGER(3) NOT NULL DEFAULT 0
	, international_titles INTEGER(3) NOT NULL DEFAULT 0

	, website VARCHAR(256) 
	, insta VARCHAR(256) 
	, meta VARCHAR(256) 
	, twttr VARCHAR(256) 
	, tktk VARCHAR(256) 
	, youtube VARCHAR(256) 

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

    , FOREIGN KEY (club_id) REFERENCES d_clubs(club_id)
    , FOREIGN KEY (association_id) REFERENCES d_associations(association_id)
    , FOREIGN KEY (country_id) REFERENCES d_countries(country_id)

)

COMMENT "Main dimension table listing all teams (e.g. Boston Ironside, FruBB)"
;

########################################################
# hierarchy ultimate events:              			   #
# 1. comepetition -> 2. event -> 3. round -> 4. fields #
########################################################

# 1. competitions

DROP TABLE IF EXISTS xa7580_db2.d_competitions;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_competitions (

	competition_id VARCHAR(10) PRIMARY KEY 
	, association_id VARCHAR(10) DEFAULT 'AAA'

	, name VARCHAR(256) UNIQUE 
	, name_raw VARCHAR(256) 	
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)
	, notes VARCHAR(500)

	, title_awarded VARCHAR(36)
	, title_type VARCHAR(36) comment "e.g. world, continental, national, etc."
	, year_established INTEGER(4)

	, surfaces VARCHAR(64) comment "e.g. grass, beach, indoor"
	, players_on_field VARCHAR(32) comment "e.g. 7 vs 7"
	, rulesets VARCHAR(64) comment "e.g. WFDF, USAU"

	, gender_divisions VARCHAR(64) comment "e.g. mixed, open, etc"
	, age_divisions VARCHAR(64) comment "e.g. masters, juniors, etc"
	, competition_divisions VARCHAR(64) comment "e.g. club, nationalteam, college, etc."

	, image VARCHAR(500)
	, website VARCHAR(256) 
	, insta VARCHAR(256) 
	, fb VARCHAR(256) 
	, twttr VARCHAR(256) 
	, tktk VARCHAR(256) 

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

    , FOREIGN KEY (association_id) REFERENCES d_associations(association_id)

)

COMMENT "Listing all competitions like WUCC, EUCF"
;

# 2. events

DROP TABLE IF EXISTS xa7580_db2.d_events;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_events (
	event_id VARCHAR(20) PRIMARY KEY 
	, competition_id VARCHAR(20) DEFAULT 'AAA'
	, association_id VARCHAR(10) DEFAULT 'AAA'

	, name VARCHAR(256) 
	, name_raw VARCHAR(256) 
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)
 
	, event_year INTEGER(4)	
	, event_start_dt DATE
	, event_end_dt DATE
	, event_location_id BIGINT(20) DEFAULT 1
	, event_qualification VARCHAR(36) comment "e.g. qualification_needed, open_entry, etc."	
	, event_rounds INTEGER(4) NOT NULL DEFAULT 1 
	, event_status VARCHAR(36) comment "e.g. finished, planned, ongoing"	
	, notes VARCHAR(500)

	, title_awarded SMALLINT(1)
	, title_name VARCHAR(48)
	, title_type VARCHAR(36) comment "e.g. world, continental, national, etc."	

	, surfaces VARCHAR(64) comment "e.g. grass, beach, indoor"
	, players_on_field VARCHAR(32) comment "e.g. 7 vs 7"
	, rulesets VARCHAR(64) comment "e.g. WFDF, USAU"

	, gender_divisions VARCHAR(64) comment "e.g. mixed, open, etc"
	, age_divisions VARCHAR(64) comment "e.g. masters, juniors, etc"
	, competition_divisions VARCHAR(64) comment "e.g. club, nationalteam, college, etc."	

	, image VARCHAR(500)
	, report_1 VARCHAR(256)
	, report_2 VARCHAR(256)
	, report_3 VARCHAR(256)
	, video_coverage VARCHAR(256)
	, website VARCHAR(256) 
	, insta VARCHAR(256) 
	, fb VARCHAR(256) 
	, twttr VARCHAR(256) 
	, tktk VARCHAR(256) 	

	, has_all_scores SMALLINT(1) NOT NULL DEFAULT 1 
	, has_all_spirit SMALLINT(1) NOT NULL DEFAULT 0
	, has_spirit_winner SMALLINT(1) NOT NULL DEFAULT 0
	, has_all_results SMALLINT(1) NOT NULL DEFAULT 1 
	, has_first_place SMALLINT(1) NOT NULL DEFAULT 1 
	, has_second_place SMALLINT(1) NOT NULL DEFAULT 1 
	, has_third_place SMALLINT(1) NOT NULL DEFAULT 1 

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

    , FOREIGN KEY (competition_id) REFERENCES d_competitions(competition_id)
    , FOREIGN KEY (association_id) REFERENCES d_associations(association_id)
    , FOREIGN KEY (event_location_id) REFERENCES d_locations(location_id)

)

COMMENT "Listing events like WUGC 2016, EUCF 2019 which belong to events"
;

# 3. rounds

DROP TABLE IF EXISTS xa7580_db2.d_rounds;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_rounds (
	round_id VARCHAR(30) PRIMARY KEY 
	, round_no INTEGER(4) NOT NULL DEFAULT 1
	, event_id VARCHAR(20) DEFAULT 'AAA'
	, competition_id VARCHAR(20) DEFAULT 'AAA'
	, association_id VARCHAR(10) DEFAULT 'AAA'

	, name VARCHAR(256) 
	, name_raw VARCHAR(256) 
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)
	, name_alias VARCHAR(500)	

	, is_final_round SMALLINT(1)
	, round_year INTEGER(4)	
	, round_start_dt DATE
	, round_end_dt DATE
	, round_location_id BIGINT(20) DEFAULT 1
	, round_qualification VARCHAR(36) comment "e.g. qualification_needed, open_entry, etc."	
	, round_rounds INTEGER(4) NOT NULL DEFAULT 1 
	, round_status VARCHAR(36) comment "e.g. finished, planned, ongoing"	
	, notes VARCHAR(500)

	, image VARCHAR(500)
	, report_1 VARCHAR(256)
	, report_2 VARCHAR(256)
	, report_3 VARCHAR(256)
	, video_coverage VARCHAR(256)
	, website VARCHAR(256) 
	, insta VARCHAR(256) 
	, fb VARCHAR(256) 
	, twttr VARCHAR(256) 
	, tktk VARCHAR(256) 

	, has_all_scores SMALLINT(1) NOT NULL DEFAULT 1 
	, has_all_spirit SMALLINT(1) NOT NULL DEFAULT 0

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)

    , FOREIGN KEY (event_id) REFERENCES d_events(event_id)
    , FOREIGN KEY (competition_id) REFERENCES d_competitions(competition_id)
    , FOREIGN KEY (association_id) REFERENCES d_associations(association_id)
    , FOREIGN KEY (round_location_id) REFERENCES d_locations(location_id)

)

COMMENT "Listing rounds within competitions. Normal tournament like WUCC only has one round. German Nationals have 2 rounds."
;

# 3. rounds

DROP TABLE IF EXISTS xa7580_db2.d_fields;

CREATE TABLE IF NOT EXISTS xa7580_db2.d_fields (
	
	field_id VARCHAR(128) PRIMARY KEY 
	, round_id VARCHAR(30) 
	, location_id BIGINT(20)

	, name VARCHAR(256) 
	, name_display VARCHAR(256) 
	, name_short VARCHAR(10)

	, surface VARCHAR(36) comment "e.g. beach, grass, turf"
	, state VARCHAR(36) comment "e.g. bad condition etc"
	, alignment VARCHAR(36) comment "e.g. alignment of field can indicate upwind/downwind games"
	, field_coords POINT

	, notes VARCHAR(500)
	, image VARCHAR(500)

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 

    , FOREIGN KEY (round_id) REFERENCES d_rounds(round_id)
    , FOREIGN KEY (location_id) REFERENCES d_locations(location_id)

)

COMMENT "Listing fields a round is played on."
;

#######################
# fact tables 		  #    
# - matches           #
# - results           #
#######################

# matches

DROP TABLE IF EXISTS xa7580_db2.f_matches;

CREATE TABLE IF NOT EXISTS xa7580_db2.f_matches (
	match_id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY 
	, name_raw VARCHAR(256) 
	, round_id VARCHAR(30) DEFAULT 'AAA'
	, round_no SMALLINT(1)
	, event_id VARCHAR(20) DEFAULT 'AAA'
	, competition_id VARCHAR(20) DEFAULT 'AAA'

	, start_year INTEGER(4)
	, start_dt DATE 
	, start_ts DATETIME
	, location_id BIGINT(20) DEFAULT 1
	, location_name VARCHAR(256)
	, field_id VARCHAR(128)

	, is_title_match SMALLINT(1) DEFAULT 0
	, is_placement_match SMALLINT(1) DEFAULT 0
	, is_elemination_match SMALLINT(1) DEFAULT 0
	, is_pool_match SMALLINT(1) DEFAULT 0
	, comp_placement SMALLINT(1) DEFAULT 1 comment "maximum placement teams in match are competing for"	
	, match_type VARCHAR(36) comment "e.g. pool, powerpool, elimination, placement, final, "	
	, match_name VARCHAR(36) comment "e.g. Pool A, Bracket 1-8, P5-Match"	

	, home_team_id BIGINT(20) NOT NULL 
	, home_team_id_str VARCHAR(256) 	
	, home_team_score INTEGER(2)
	, home_team_spirit DECIMAL(2,2)
	, home_team_point_diff INTEGER(2)

	, away_team_id BIGINT(20) NOT NULL 
	, away_team_id_str VARCHAR(256)
	, away_team_score INTEGER(2)
	, away_team_spirit DECIMAL(2,2)
	, away_team_point_diff INTEGER(2)

	, winner_team_id BIGINT(20)
	, looser_team_id BIGINT(20)
	, point_diff INTEGER(2)
	, point_diff_factor DECIMAL(2,2)
	, is_universe_game SMALLINT(1)
	#, is_blowout_game SMALLINT(1)
	#, is_close_game SMALLINT(1)

	, has_observer SMALLINT(1) DEFAULT NULL
	, has_referee SMALLINT(1) DEFAULT 0
	, is_draw SMALLINT(1) NOT NULL DEFAULT 0 
	, is_surrender SMALLINT(1) NOT NULL DEFAULT 0 
	, is_disqualification SMALLINT(1) NOT NULL DEFAULT 0 
	, is_played SMALLINT(1) NOT NULL DEFAULT 1 
	, is_postponed SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid_score SMALLINT(1) DEFAULT 1 
	, is_result_score SMALLINT(1) DEFAULT 0
	, has_spirit_scores SMALLINT(1) NOT NULL DEFAULT 0

	, gender_division VARCHAR(32) comment "e.g. mixed, open, etc"
	, age_division VARCHAR(32) comment "e.g. masters, juniors, etc"
	, competition_division VARCHAR(32) comment "e.g. club, nationalteam, college, etc."		

	, notes VARCHAR(500)

	, has_weather_data SMALLINT(1) NOT NULL DEFAULT 0	
	, weather_temp DECIMAL(2,1)
	, weather_rain DECIMAL(3,1)
	, weather_sun DECIMAL(2,1)
	, weather_wind DECIMAL(3,1)
	, weather_gusts DECIMAL(3,1)
	, weather_icon VARCHAR(256)
	, weather_source VARCHAR(256)

	, image VARCHAR(500)
	, report_1 VARCHAR(256)
	, report_2 VARCHAR(256)
	, report_3 VARCHAR(256)
	, video_coverage VARCHAR(256)

	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)
	, source_file VARCHAR(256)

   	, FOREIGN KEY (event_id) REFERENCES d_events(event_id)
    , FOREIGN KEY (competition_id) REFERENCES d_competitions(competition_id)
    , FOREIGN KEY (home_team_id) REFERENCES d_teams(team_id)
    , FOREIGN KEY (away_team_id) REFERENCES d_teams(team_id)
    , FOREIGN KEY (location_id) REFERENCES d_locations(location_id)	
    , FOREIGN KEY (field_id) REFERENCES d_fields(field_id)	

)

COMMENT "Fact table containing all ultimate matches"
;

# results

DROP TABLE IF EXISTS xa7580_db2.f_results;

CREATE TABLE IF NOT EXISTS xa7580_db2.f_results (

	result_id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY 
	, event_id VARCHAR(20) DEFAULT 'AAA'
	, competition_id VARCHAR(20) DEFAULT 'AAA'

	, placement INTEGER(2)
	, team_id BIGINT(20) NOT NULL
	, team_id_str VARCHAR(256) 	

	, no_games INTEGER(2) 
	, no_wins INTEGER(2)
	, no_losses INTEGER(2)
	, no_draws INTEGER(2)
	, score_for INTEGER(4)
	, score_against INTEGER(4)
	, score_diff INTEGER(4)

	, spirit_rating DECIMAL(2,1)
	, spirit_placement INTEGER(2)
	, is_spirit_winner SMALLINT(1)

	, is_qualification_placement SMALLINT(1) 
	, qualification_event_name VARCHAR(36)
	, qualification_event_id VARCHAR(10) DEFAULT 'AAA'

	, is_demotion_placement SMALLINT(1)
	, demotion_event_name VARCHAR(36)
	, demotion_event_id VARCHAR(10)	DEFAULT 'AAA'

	, notes VARCHAR(500)

	, gender_division VARCHAR(32) comment "e.g. mixed, open, etc"
	, age_division VARCHAR(32) comment "e.g. masters, juniors, etc"
	, competition_division VARCHAR(32) comment "e.g. club, nationalteam, college, etc."		


	, is_hidden SMALLINT(1) NOT NULL DEFAULT 0 
	, is_valid SMALLINT(1) NOT NULL DEFAULT 1 

	, remarks VARCHAR(500)
	, update_ts DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
	, insert_ts DATETIME DEFAULT CURRENT_TIMESTAMP 
	, source_name VARCHAR(36)
	, source_url VARCHAR(256)
	, source_file VARCHAR(256)

	, FOREIGN KEY (competition_id) REFERENCES d_competitions(competition_id)
	, FOREIGN KEY (event_id) REFERENCES d_events(event_id)
	, FOREIGN KEY (qualification_event_id) REFERENCES d_events(event_id)
	, FOREIGN KEY (demotion_event_id) REFERENCES d_events(event_id)
    , FOREIGN KEY (team_id) REFERENCES d_teams(team_id)

)

COMMENT "Fact table containing all event results"
;