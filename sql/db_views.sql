# view story SQL to aggregate event data

CREATE OR REPLACE VIEW f_results_data_v AS 

select  r.result_id
        , r.competition_id
		, r.event_id
		, r.competition_division
        , r.age_division
        , r.gender_division
		, r.team_id
        , r.team_id_str
        , count(*) as no_games
        , sum(case when m.winner_team_id = r.team_id then 1 else 0 end) as no_wins
        , sum(case when m.looser_team_id = r.team_id then 1 else 0 end) as no_losses
        , sum(m.is_draw) as no_draws
        , sum(case when r.team_id = m.home_team_id then m.home_team_score else m.away_team_score end) as score_for
        , sum(case when r.team_id != m.home_team_id then m.home_team_score else m.away_team_score end) as score_against
        , sum(case when r.team_id = m.home_team_id then m.home_team_point_diff else m.away_team_point_diff end) as score_diff
        , round(avg(case when r.team_id = m.home_team_id then m.home_team_spirit else m.away_team_spirit end),3) as spirit_rating
        
FROM f_results r 
    
INNER JOIN f_matches m 
	ON 	m.event_id = r.event_id
       	AND (r.team_id = m.away_team_id or r.team_id = m.home_team_id)    

GROUP BY r.result_id
		, r.event_id
        , r.competition_id
		, r.competition_division
        , r.age_division
        , r.gender_division
		, r.team_id
        , r.team_id_str