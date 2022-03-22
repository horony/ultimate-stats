#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

Loading event results into the database
In this process team_ids are created if not existing

@author: lennart

"""

# load packages

import pandas as pd
from sqlalchemy import create_engine

# mySQL connection
from settings import db_user, db_pass, db_port, db_name
import re

# input

unstructured = {
   "WUCC_2018": {
           "file": "2018_wucc_results.csv"
           , "event": "wucc_2018"
           , "competition": "wucc"
           , "load_now" : 1
    }
}
   
def clean_identifier_str(string_input):
    string_input = re.sub(r'[^a-zA-Z0-9]+', '', string_input)
    string_input = string_input.lower()
    return string_input
    
event_result_dict = unstructured

if 1 == 1:
  for u, ui in event_result_dict.items():
    print("Event:", u, "Load:", ui['load_now'])
    
    if ui['load_now'] == 1:
        
        """
        
        Parse Data
        
        """        
        
        file_path = "../assets/data/results/unstructured/" + ui['file']
        print("Reading file:", file_path)
        
        read_file = pd.read_csv(    file_path
                                    , delimiter = ','
                                    #, skiprows = c_info['csv_skiprows']
                                    , encoding = 'utf8'
                                    #, decimal = c_info['csv_decimal']
                                    #, thousands = c_info['csv_thousands']
                                    )
        
        # clean team name
        read_file['team'] = read_file['team'].apply(clean_identifier_str)
        
        # create abbrevation for gender division
        read_file.loc[read_file['gender_division'].str.contains("open"),'gender_division_short'] = '_o'
        read_file.loc[read_file['gender_division'].str.contains("women"),'gender_division_short'] = '_w'
        read_file.loc[read_file['gender_division'].str.contains("mixed"),'gender_division_short'] = '_x'
 
        # create abbrevation for age division       
        read_file.loc[read_file['age_division'].str.contains("regular"),'age_division_short'] = ''
        read_file.loc[read_file['age_division'].str.contains("masters"),'age_division_short'] = '_m'
        read_file.loc[read_file['age_division'].str.contains("grandmasters"),'age_division_short'] = '_gm'
        read_file.loc[read_file['age_division'].str.contains("U24"),'age_division_short'] = '_u24'
        read_file.loc[read_file['age_division'].str.contains("U23"),'age_division_short'] = '_u23'
        read_file.loc[read_file['age_division'].str.contains("U20"),'age_division_short'] = '_u20'
        read_file.loc[read_file['age_division'].str.contains("U20"),'age_division_short'] = '_u17'
 
        # create abbrevation for competition division       
        read_file.loc[read_file['competition_division'].str.contains("club"),'competition_division_short'] = ''
        read_file.loc[read_file['competition_division'].str.contains("college"),'competition_division_short'] = '_clg'
        read_file.loc[read_file['competition_division'].str.contains("nationalteam"),'competition_division_short'] = '_nt'
        read_file.loc[read_file['competition_division'].str.contains("pro"),'competition_division_short'] = '_pro'
        
        # combine team name and abbrevations to speaking team id
        read_file['team_id_str'] = read_file['team'] + read_file['gender_division_short'] + read_file['age_division_short'] + read_file['competition_division_short']
        
        # define source file
        read_file['source_file'] = ui['file']
        
        # define mysql db connection
        engine_input = 'mysql+mysqlconnector://'+db_user+':'+db_pass+'@localhost:'+db_port+'/'+db_name
        
        """
        
        Insert new team ids keys into database table d_teams 
        Only if they are not already existing
        
        """
        
        unique_teams =  read_file['team_id_str']

        if unique_teams.is_unique:
            
            try:
                engine = create_engine(engine_input, echo=False) 
                
                # create tmp table for update
                unique_teams.to_sql(name='tmp_team_ids', con=engine, index=False, if_exists='replace')
                
                # check if new IDs can be found
                sql_select = engine.execute('SELECT count(*) as cnt FROM tmp_team_ids WHERE tmp_team_ids.team_id_str not in (SELECT DISTINCT COALESCE(team_id_str,0) FROM d_teams)')
                sql_first_row = sql_select.fetchone()
                cnt =  sql_first_row['cnt']
                
                if cnt > 0:
                    
                    # insert new IDs
                    with engine.connect() as con:
                        con.execute('''
                                        INSERT INTO d_teams (team_id_str)
                                        SELECT team_id_str FROM tmp_team_ids
                                        WHERE tmp_team_ids.team_id_str not in (SELECT DISTINCT COALESCE(team_id_str,0) FROM d_teams);
                                    ''')            
                        con.execute('DROP TABLE tmp_team_ids;')    
                
                    db_message = "Success inserting new " + str(cnt) + " IDs into table d_teams!"
                    
                else:
                    db_message = "Found " + str(cnt) + " new IDs for table d_teams!"
    
            except:
                db_message = "Fail inserting new IDs into table d_teams!"
                      
            print(db_message)  
            
        else:
            print("team_id_str nicht unique:")
            print(unique_teams.duplicated)       
            
        
        """
        
        Insert the event results into database table f_results
        
        """

        if 1 == 1:
            
            try:
                engine = create_engine(engine_input, echo=False) 
                read_file.to_sql(name='tmp_results', con=engine, index=False, if_exists='replace')

                with engine.connect() as con:
                    con.execute('''
                                    INSERT INTO f_results 
                                        ( event_id
                                         , competition_id
                                         , placement
                                         , team_id
                                         , team_id_str
                                         , no_games
                                         , no_wins
                                         , no_losses
                                         , no_draws
                                         , score_for
                                         , score_against
                                         , score_diff
                                         , spirit_rating
                                         , is_spirit_winner
                                         , is_qualification_placement
                                         , qualification_event_name
                                         , qualification_event_id
                                         , is_demotion_placement
                                         , demotion_event_name
                                         , demotion_event_id	
                                         , gender_division
                                         , age_division
                                         , competition_division
                                         , source_url
                                         , source_file
                                         )
                                        
                                    SELECT  tmp.event_id
                                            , tmp.competition_id
                                            , tmp.placement
                                            , tm.team_id                                         
                                            , tmp.team_id_str
                                            , tmp.no_games
                                            , tmp.no_wins
                                            , tmp.no_losses
                                            , tmp.no_draws
                                            , tmp.score_for
                                            , tmp.score_against
                                            , tmp.score_for - tmp.score_against
                                            , tmp.spirit_rating
                                            , tmp.is_spirit_winner
                                            , tmp.is_qualification_placement
                                            , tmp.qualification_event_name
                                            , tmp.qualification_event_id
                                            , tmp.is_demotion_placement
                                            , tmp.demotion_event_name
                                            , tmp.demotion_event_id	
                                            , tmp.gender_division
                                            , tmp.age_division
                                            , tmp.competition_division
                                            , tmp.source_url
                                            , tmp.source_file
                                            
                                    FROM tmp_results tmp
                                    
                                    LEFT JOIN d_teams tm
                                        ON tm.team_id_str = tmp.team_id_str
                                    ;
                                ''')      

                    con.execute('DROP TABLE tmp_results;')    
            
                db_message = "Success updating table f_results!"
            
            except:
                db_message = "Fail updating table f_results!"
            
            print(db_message)  

#load_unstructured(unstructured)