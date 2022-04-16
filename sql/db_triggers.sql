############################################################################################################################################
# f_results

# competition_id

DROP TRIGGER IF EXISTS f_results_insert_competition_id;

DELIMITER $$

CREATE TRIGGER f_results_insert_competition_id BEFORE INSERT ON f_results FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_results WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_results_update_competition_id;

DELIMITER $$

CREATE TRIGGER f_results_update_competition_id BEFORE UPDATE ON f_results FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_results WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;

# event_id

DROP TRIGGER IF EXISTS f_results_insert_event_id;

DELIMITER $$

CREATE TRIGGER f_results_insert_event_id BEFORE INSERT ON f_results FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_results WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;

DROP TRIGGER IF EXISTS f_results_update_event_id;

DELIMITER $$

CREATE TRIGGER f_results_update_event_id BEFORE UPDATE ON f_results FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_results WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_results_insert_event_id;

DELIMITER $$

CREATE TRIGGER f_results_insert_event_id BEFORE INSERT ON f_results FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_results WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;


############################################################################################################################################
# f_matches

# competition_id

DROP TRIGGER IF EXISTS f_matches_insert_competition_id;

DELIMITER $$

CREATE TRIGGER f_matches_insert_competition_id BEFORE INSERT ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_matches_update_competition_id;

DELIMITER $$

CREATE TRIGGER f_matches_update_competition_id BEFORE UPDATE ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;

# event_id

DROP TRIGGER IF EXISTS f_matches_insert_event_id;

DELIMITER $$

CREATE TRIGGER f_matches_insert_event_id BEFORE INSERT ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_matches_update_event_id;

DELIMITER $$

CREATE TRIGGER f_matches_update_event_id BEFORE UPDATE ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;

# round_id

DROP TRIGGER IF EXISTS f_matches_insert_round_id;

DELIMITER $$

CREATE TRIGGER f_matches_insert_round_id BEFORE INSERT ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE round_id = NEW.round_id) THEN
    INSERT IGNORE INTO d_rounds (round_id)
    VALUES (NEW.round_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_matches_update_round_id;

DELIMITER $$

CREATE TRIGGER f_matches_update_round_id BEFORE UPDATE ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE round_id = NEW.round_id) THEN
    INSERT IGNORE INTO d_rounds (round_id)
    VALUES (NEW.round_id);
END IF;

END$$

DELIMITER ;

# location_name

DROP TRIGGER IF EXISTS f_matches_insert_location_name;

DELIMITER $$

CREATE TRIGGER f_matches_insert_location_name BEFORE INSERT ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE location_name = NEW.location_name) THEN
    INSERT IGNORE INTO d_locations (location_name)
    VALUES (NEW.location_name);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_matches_update_location_name;

DELIMITER $$

CREATE TRIGGER f_matches_update_location_name BEFORE UPDATE ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE location_name = NEW.location_name) THEN
    INSERT IGNORE INTO d_locations (location_name)
    VALUES (NEW.location_name);
END IF;

END$$

DELIMITER ;

# field_id

DROP TRIGGER IF EXISTS f_matches_insert_field_id;

DELIMITER $$

CREATE TRIGGER f_matches_insert_field_id BEFORE INSERT ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE field_id = NEW.field_id) THEN
    INSERT IGNORE INTO d_fields (field_id)
    VALUES (NEW.field_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS f_matches_update_field_id;

DELIMITER $$

CREATE TRIGGER f_matches_update_field_id BEFORE UPDATE ON f_matches FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM f_matches WHERE field_id = NEW.field_id) THEN
    INSERT IGNORE INTO d_fields (field_id)
    VALUES (NEW.field_id);
END IF;

END$$

DELIMITER ;


############################################################################################################################################
# d_teams

# club_id

DROP TRIGGER IF EXISTS d_teams_insert_club_id;

DELIMITER $$

CREATE TRIGGER d_teams_insert_club_id BEFORE INSERT ON d_teams FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_teams WHERE club_id = NEW.club_id) THEN
    INSERT IGNORE INTO d_clubs (club_id)
    VALUES (NEW.club_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_teams_update_club_id;

DELIMITER $$

CREATE TRIGGER d_teams_update_club_id BEFORE UPDATE ON d_teams FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_teams WHERE club_id = NEW.club_id) THEN
    INSERT IGNORE INTO d_clubs (club_id)
    VALUES (NEW.club_id);
END IF;

END$$

DELIMITER ;

# association_id

DROP TRIGGER IF EXISTS d_teams_insert_association_id;

DELIMITER $$

CREATE TRIGGER d_teams_insert_association_id BEFORE INSERT ON d_teams FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_teams WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_teams_update_association_id;

DELIMITER $$

CREATE TRIGGER d_teams_update_association_id BEFORE UPDATE ON d_teams FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_teams WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;

# country_id

DROP TRIGGER IF EXISTS d_teams_insert_country_id;

DELIMITER $$

CREATE TRIGGER d_teams_insert_country_id BEFORE INSERT ON d_teams FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_teams WHERE country_id = NEW.country_id) THEN
    INSERT IGNORE INTO d_countries (country_id)
    VALUES (NEW.country_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_teams_update_country_id;

DELIMITER $$

CREATE TRIGGER d_teams_update_country_id BEFORE UPDATE ON d_teams FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_teams WHERE country_id = NEW.country_id) THEN
    INSERT IGNORE INTO d_countries (country_id)
    VALUES (NEW.country_id);
END IF;

END$$

DELIMITER ;

############################################################################################################################################
# d_associations

DROP TRIGGER IF EXISTS d_associations_insert_country_id;

DELIMITER $$

CREATE TRIGGER d_associations_insert_country_id BEFORE INSERT ON d_associations FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_associations WHERE country_id = NEW.country_id) THEN
    INSERT IGNORE INTO d_countries (country_id)
    VALUES (NEW.country_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_associations_update_country_id;

DELIMITER $$

CREATE TRIGGER d_associations_update_country_id BEFORE UPDATE ON d_associations FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_associations WHERE country_id = NEW.country_id) THEN
    INSERT IGNORE INTO d_countries (country_id)
    VALUES (NEW.country_id);
END IF;

END$$

DELIMITER ;

############################################################################################################################################
# d_clubs

DROP TRIGGER IF EXISTS d_clubs_insert_country_id;

DELIMITER $$

CREATE TRIGGER d_clubs_insert_country_id BEFORE INSERT ON d_clubs FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_clubs WHERE country_id = NEW.country_id) THEN
    INSERT IGNORE INTO d_countries (country_id)
    VALUES (NEW.country_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_clubs_update_country_id;

DELIMITER $$

CREATE TRIGGER d_clubs_update_country_id BEFORE UPDATE ON d_clubs FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_clubs WHERE country_id = NEW.country_id) THEN
    INSERT IGNORE INTO d_countries (country_id)
    VALUES (NEW.country_id);
END IF;

END$$

DELIMITER ;

# association_id

DROP TRIGGER IF EXISTS d_clubs_insert_association_id;

DELIMITER $$

CREATE TRIGGER d_clubs_insert_association_id BEFORE INSERT ON d_clubs FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_clubs WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_clubs_update_association_id;

DELIMITER $$

CREATE TRIGGER d_clubs_update_association_id BEFORE UPDATE ON d_clubs FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_clubs WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;

############################################################################################################################################
# d_competitions

# association_id

DROP TRIGGER IF EXISTS d_competitions_insert_association_id;

DELIMITER $$

CREATE TRIGGER d_competitions_insert_association_id BEFORE INSERT ON d_competitions FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_competitions WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_competitions_update_association_id;

DELIMITER $$

CREATE TRIGGER d_competitions_update_association_id BEFORE UPDATE ON d_competitions FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_competitions WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;


############################################################################################################################################
# d_events

# competition_id

DROP TRIGGER IF EXISTS d_events_insert_competition_id;

DELIMITER $$

CREATE TRIGGER d_events_insert_competition_id BEFORE INSERT ON d_events FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_events WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_events_update_competition_id;

DELIMITER $$

CREATE TRIGGER d_events_update_competition_id BEFORE UPDATE ON d_events FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_events WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;

# association_id

DROP TRIGGER IF EXISTS d_events_insert_association_id;

DELIMITER $$

CREATE TRIGGER d_events_insert_association_id BEFORE INSERT ON d_events FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_events WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_events_update_association_id;

DELIMITER $$

CREATE TRIGGER d_events_update_association_id BEFORE UPDATE ON d_events FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_events WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;

# event_location_id

DROP TRIGGER IF EXISTS d_events_insert_location_id;

DELIMITER $$

CREATE TRIGGER d_events_insert_location_id BEFORE INSERT ON d_events FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_events WHERE event_location_id = NEW.event_location_id) THEN
    INSERT IGNORE INTO d_locations (location_id)
    VALUES (NEW.event_location_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_events_update_location_id;

DELIMITER $$

CREATE TRIGGER d_events_update_location_id BEFORE UPDATE ON d_events FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_events WHERE event_location_id = NEW.event_location_id) THEN
    INSERT IGNORE INTO d_locations (location_id)
    VALUES (NEW.event_location_id);
END IF;

END$$

DELIMITER ;

############################################################################################################################################
# d_rounds

# competition_id

DROP TRIGGER IF EXISTS d_rounds_insert_competition_id;

DELIMITER $$

CREATE TRIGGER d_rounds_insert_competition_id BEFORE INSERT ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_rounds_update_competition_id;

DELIMITER $$

CREATE TRIGGER d_rounds_update_competition_id BEFORE UPDATE ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE competition_id = NEW.competition_id) THEN
    INSERT IGNORE INTO d_competitions (competition_id)
    VALUES (NEW.competition_id);
END IF;

END$$

DELIMITER ;

# association_id

DROP TRIGGER IF EXISTS d_rounds_insert_association_id;

DELIMITER $$

CREATE TRIGGER d_rounds_insert_association_id BEFORE INSERT ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_rounds_update_association_id;

DELIMITER $$

CREATE TRIGGER d_rounds_update_association_id BEFORE UPDATE ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE association_id = NEW.association_id) THEN
    INSERT IGNORE INTO d_associations (association_id)
    VALUES (NEW.association_id);
END IF;

END$$

DELIMITER ;

# event_location_id

DROP TRIGGER IF EXISTS d_rounds_insert_location_id;

DELIMITER $$

CREATE TRIGGER d_rounds_insert_location_id BEFORE INSERT ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE round_location_id = NEW.round_location_id) THEN
    INSERT IGNORE INTO d_locations (location_id)
    VALUES (NEW.round_location_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_rounds_update_location_id;

DELIMITER $$

CREATE TRIGGER d_rounds_update_location_id BEFORE UPDATE ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE round_location_id = NEW.round_location_id) THEN
    INSERT IGNORE INTO d_locations (location_id)
    VALUES (NEW.round_location_id);
END IF;

END$$

DELIMITER ;

# event_id

DROP TRIGGER IF EXISTS d_rounds_insert_event_id;

DELIMITER $$

CREATE TRIGGER d_rounds_insert_event_id BEFORE INSERT ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;


DROP TRIGGER IF EXISTS d_rounds_update_event_id;

DELIMITER $$

CREATE TRIGGER d_rounds_update_event_id BEFORE UPDATE ON d_rounds FOR EACH ROW
BEGIN

IF NOT EXISTS (SELECT 1 FROM d_rounds WHERE event_id = NEW.event_id) THEN
    INSERT IGNORE INTO d_events (event_id)
    VALUES (NEW.event_id);
END IF;

END$$

DELIMITER ;