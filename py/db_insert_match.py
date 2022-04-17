#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 16 2022

@author: lennart

Script inserts new locations and fields, then inserts matches and then updates results with aggregated data

"""

# input

def DBinsertMatch(df, col_location_id, col_location_name, col_field_id, col_field_name):
    
    print('... called function DBinsertMatch')
       
    # load packages
    from sqlalchemy import create_engine
    
    # mySQL connection and define mysql db connection
    from settings import db_user, db_pass, db_port, db_name
    engine_input = 'mysql+mysqlconnector://'+db_user+':'+db_pass+'@localhost:'+db_port+'/'+db_name    
    
    """
     
    Insert new location id keys into database table d_locations
    Only if they are not already existing
     
    """

    print('... searching for new locations')
    
    unique_locations = df[[col_location_id,col_location_name]]
    unique_locations = unique_locations.drop_duplicates(keep='first')
    unique_locations = unique_locations.reset_index(drop = True)
    
    if unique_locations[col_location_id].is_unique:
        
        try:
            engine = create_engine(engine_input, echo=False) 
         
            # create tmp table for update
            unique_locations.to_sql(name='tmp_location_ids', con=engine, index=False, if_exists='replace')
            print('created tmp_location_ids')
            
            # check if new IDs can be found
            sql_select = engine.execute('SELECT count(*) as cnt FROM tmp_location_ids WHERE tmp_location_ids.location_id not in (SELECT DISTINCT COALESCE(location_id,0) FROM d_locations)')
            sql_first_row = sql_select.fetchone()
            cnt =  sql_first_row['cnt']
            
            print('Found ' + str(cnt) + ' new IDs')
            
            if cnt > 0:
                # insert new IDs
                with engine.connect() as con:
                    con.execute('''
                                INSERT INTO d_locations (location_id, name, name_display)
                                SELECT location_id, location_name, location_name FROM tmp_location_ids
                                WHERE tmp_location_ids.location_id not in (SELECT DISTINCT COALESCE(location_id,0) FROM d_locations)
                                ;''')   
                    print('Insert into d_locations complete')
                
                    #con.execute('DROP TABLE tmp_team_ids;')    
                    #print('Dropped tmp_team_ids')
    
                db_message = "Success inserting new " + str(cnt) + " IDs into table d_locations!"
             
            else:
                db_message = "Found " + str(cnt) + " new IDs for table d_locations!"
        
        except:
             db_message = "Fail inserting new IDs into table d_locations!"
        
        print(db_message)  
             
     
    else:
        print("location_id nicht unique:")
        print(unique_locations.duplicated)       
        
    """
     
    Insert new field id keys into database table d_fields
    Only if they are not already existing
     
    """

    print('... searching for new fields')
    
    unique_fields = df[[col_field_id,col_field_name,col_location_id]]
    unique_fields = unique_fields.drop_duplicates(keep='first')
    unique_fields = unique_fields.reset_index(drop = True)
    
    if unique_fields[col_field_id].is_unique:
        
        try:
            engine = create_engine(engine_input, echo=False) 
         
            # create tmp table for update
            unique_fields.to_sql(name='tmp_field_ids', con=engine, index=False, if_exists='replace')
            print('created tmp_field_ids')
            
            # check if new IDs can be found
            sql_select = engine.execute('SELECT count(*) as cnt FROM tmp_field_ids WHERE tmp_field_ids.field_id not in (SELECT DISTINCT COALESCE(field_id,0) FROM d_fields)')
            sql_first_row = sql_select.fetchone()
            cnt =  sql_first_row['cnt']
            
            print('Found ' + str(cnt) + ' new IDs')
            
            if cnt > 0:
                # insert new IDs
                with engine.connect() as con:
                    con.execute('''
                                INSERT INTO d_fields (field_id, name, name_display, location_id)
                                SELECT field_id, field_name, field_name, location_id FROM tmp_field_ids
                                WHERE tmp_field_ids.field_id not in (SELECT DISTINCT COALESCE(field_id,0) FROM d_fields)
                                ;''')   
                    print('Insert into d_fields complete')
                
                    #con.execute('DROP TABLE tmp_team_ids;')    
                    #print('Dropped tmp_team_ids')
    
                db_message = "Success inserting new " + str(cnt) + " IDs into table d_fields!"
             
            else:
                db_message = "Found " + str(cnt) + " new IDs for table d_fields!"
        
        except:
             db_message = "Fail inserting new IDs into table d_fields!"
        
        print(db_message)  
             
     
    else:
        print("field_id nicht unique:")
        print(unique_locations.duplicated)  
        
     
    """
     
    Insert the match results into database table f_matches
     
    """

    print('... inserting event match data')

    try:
        engine = create_engine(engine_input, echo=False) 
        df.to_sql(name='tmp_matches', con=engine, index=False, if_exists='replace')

        with engine.connect() as con:
            con.execute('''
                            INSERT INTO f_matches
                                 (  round_no 
                                    , round_id  
                                    	, event_id 
                                    	, competition_id 
                                    	, start_year 
                                    	, start_dt 
                                    	, start_ts 
                                    	, location_id 
                                    	, field_id
                                    	, home_team_id
                                    	, home_team_id_str 
                                    	, home_team_score 
                                    	, home_team_spirit 
                                    	, home_team_point_diff
                                    	, away_team_id 
                                    	, away_team_id_str
                                    	, away_team_score 
                                    	, away_team_spirit 
                                    	, away_team_point_diff 
                                    	, winner_team_id 
                                    	, looser_team_id 
                                    	, point_diff 
                                    	, point_diff_factor 
                                    	, is_universe_game 
                                    	, is_draw 
                                    	, has_spirit_scores 
                                    	, gender_division 
                                    	, age_division 
                                    	, competition_division 
                                    , source_file   
                                    , source_name 
                                    	, source_url 
                                  )
                                 
                             SELECT tmp.round_no 
                                    , tmp.round_id
                                    	, tmp.event_id 
                                    	, tmp.competition_id 
                                    	, tmp.start_year 
                                    	, tmp.start_dt 
                                    	, tmp.start_ts 
                                    	, tmp.location_id 
                                    	, tmp.field_id
                                    , th.team_id
                                    	, tmp.home_team_id_str 
                                    	, tmp.home_team_score 
                                    	, tmp.home_team_spirit 
                                    	, tmp.home_team_point_diff
                                    , ta.team_id
                                    	, tmp.away_team_id_str
                                    	, tmp.away_team_score 
                                    	, tmp.away_team_spirit 
                                    	, tmp.away_team_point_diff 
                                    	, CASE  WHEN tmp.home_team_score > tmp.away_team_score THEN th.team_id 
                                            WHEN tmp.home_team_score < tmp.away_team_score THEN ta.team_id 
                                            ELSE NULL END
                                    	, CASE  WHEN tmp.home_team_score < tmp.away_team_score THEN th.team_id 
                                            WHEN tmp.home_team_score > tmp.away_team_score THEN ta.team_id 
                                            ELSE NULL END                                    	
                                    , tmp.point_diff 
                                    	, tmp.point_diff_factor ### needs to be caluclated here ###
                                    	, tmp.is_universe_game 
                                    	, tmp.is_draw 
                                    	, tmp.has_spirit_scores 
                                    	, tmp.gender_division 
                                    	, tmp.age_division 
                                    	, tmp.competition_division 	
                                    , tmp.source_file
                                    	, tmp.source_name 
                                    	, tmp.source_url 
                                     
                             FROM tmp_matches tmp
                             
                             LEFT JOIN d_teams th
                                 ON th.team_id_str = tmp.home_team_id_str
                                 
                             LEFT JOIN d_teams ta
                                 ON ta.team_id_str = tmp.away_team_id_str                                 
                             ;
                    ''')      

            #con.execute('DROP TABLE tmp_results;')    
     
            db_message = "Success updating table f_matches!"
     
    except:
        db_message = "Fail updating table f_matches!"
     
    print(db_message)  
    
    """
    UNDER CONSTRUCTION
    Update the f_results with f_matches
    CREATE A VIEW FOR SPIRIT RANKING
    SELECT 	r.event_id
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
        
        FROM `f_results` r
        LEFT JOIN f_matches m
        	ON 	m.event_id = r.event_id
            	AND (r.team_id = m.away_team_id or r.team_id = m.home_team_id)

    WHERE r.event_id = 'xeucf_2021'
    GROUP BY r.event_id, r.team_id, r.team_id_str;
    
    print('... updating f_results with f_matches')
    
    try:
        engine = create_engine(engine_input, echo=False) 
        df.to_sql(name='tmp_matches', con=engine, index=False, if_exists='replace')
    
        with engine.connect() as con:
            con.execute('''
                            INSERT INTO f_matches
                                 (  round_no 
                                    , round_id  
                                    	, event_id 
                                    	, competition_id 
                                    	, start_year 
                                    	, start_dt 
                                    	, start_ts 
                                    	, location_id 
                                    	, field_id
                                    	, home_team_id
                                    	, home_team_id_str 
                                    	, home_team_score 
                                    	, home_team_spirit 
                                    	, home_team_point_diff
                                    	, away_team_id 
                                    	, away_team_id_str
                                    	, away_team_score 
                                    	, away_team_spirit 
                                    	, away_team_point_diff 
                                    	, winner_team_id 
                                    	, looser_team_id 
                                    	, point_diff 
                                    	, point_diff_factor 
                                    	, is_universe_game 
                                    	, is_draw 
                                    	, has_spirit_scores 
                                    	, gender_division 
                                    	, age_division 
                                    	, competition_division 
                                    , source_file   
                                    , source_name 
                                    	, source_url 
                                  )
                                 
                             SELECT tmp.round_no 
                                    , tmp.round_id
                                    	, tmp.event_id 
                                    	, tmp.competition_id 
                                    	, tmp.start_year 
                                    	, tmp.start_dt 
                                    	, tmp.start_ts 
                                    	, tmp.location_id 
                                    	, tmp.field_id
                                    , th.team_id
                                    	, tmp.home_team_id_str 
                                    	, tmp.home_team_score 
                                    	, tmp.home_team_spirit 
                                    	, tmp.home_team_point_diff
                                    , ta.team_id
                                    	, tmp.away_team_id_str
                                    	, tmp.away_team_score 
                                    	, tmp.away_team_spirit 
                                    	, tmp.away_team_point_diff 
                                    	, CASE  WHEN tmp.home_team_score > tmp.away_team_score THEN th.team_id 
                                            WHEN tmp.home_team_score < tmp.away_team_score THEN ta.team_id 
                                            ELSE NULL END
                                    	, CASE  WHEN tmp.home_team_score < tmp.away_team_score THEN th.team_id 
                                            WHEN tmp.home_team_score > tmp.away_team_score THEN ta.team_id 
                                            ELSE NULL END                                    	
                                    , tmp.point_diff 
                                    	, tmp.point_diff_factor 
                                    	, tmp.is_universe_game 
                                    	, tmp.is_draw 
                                    	, tmp.has_spirit_scores 
                                    	, tmp.gender_division 
                                    	, tmp.age_division 
                                    	, tmp.competition_division 	
                                    , tmp.source_file
                                    	, tmp.source_name 
                                    	, tmp.source_url 
                                     
                             FROM tmp_matches tmp
                             
                             LEFT JOIN d_teams th
                                 ON th.team_id_str = tmp.home_team_id_str
                                 
                             LEFT JOIN d_teams ta
                                 ON ta.team_id_str = tmp.away_team_id_str                                 
                             ;
                    ''')      
    
            #con.execute('DROP TABLE tmp_results;')    
     
            db_message = "Success updating table f_matches!"
     
    except:
        db_message = "Fail updating table f_matches!"
     
    print(db_message)
    """