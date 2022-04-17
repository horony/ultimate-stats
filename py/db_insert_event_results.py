#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 22:15:26 2022

@author: lennart
"""

# input

def DBinsertResult(df, col):
    
    print('... called function DBinsertResult')
    print('... searching for new teams')
    unique_teams = df[col] #e.g. read_file['team_id_str']
    unique_teams = unique_teams.reset_index(drop = True)
    #print(unique_teams.head())

    # load packages
    from sqlalchemy import create_engine
    
    # mySQL connection
    from settings import db_user, db_pass, db_port, db_name
    
    # define mysql db connection
    engine_input = 'mysql+mysqlconnector://'+db_user+':'+db_pass+'@localhost:'+db_port+'/'+db_name    
    
    """
     
    Insert new team ids keys into database table d_teams 
    Only if they are not already existing
     
    """
 
    if unique_teams.is_unique:
        
        try:
            engine = create_engine(engine_input, echo=False) 
         
            # create tmp table for update
            unique_teams.to_sql(name='tmp_team_ids', con=engine, index=False, if_exists='replace')
            print('created tmp_team_ids')
            # check if new IDs can be found
            sql_select = engine.execute('SELECT count(*) as cnt FROM tmp_team_ids WHERE tmp_team_ids.team_id_str not in (SELECT DISTINCT COALESCE(team_id_str,0) FROM d_teams)')
            sql_first_row = sql_select.fetchone()
            cnt =  sql_first_row['cnt']
            
            print('Found ' + str(cnt) + ' new IDs')
            if cnt > 0:
                # insert new IDs
                with engine.connect() as con:
                    con.execute('''
                                INSERT INTO d_teams (team_id_str)
                                SELECT team_id_str FROM tmp_team_ids
                                WHERE tmp_team_ids.team_id_str not in (SELECT DISTINCT COALESCE(team_id_str,0) FROM d_teams)
                                ;''')   
                    print('Insert into d_teams complete')
                
                    #con.execute('DROP TABLE tmp_team_ids;')    
                    #print('Dropped tmp_team_ids')
    
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
        print('... inserting event result data')

        try:
            engine = create_engine(engine_input, echo=False) 
            df.to_sql(name='tmp_results', con=engine, index=False, if_exists='replace')

            with engine.connect() as con:
                con.execute('''
                            INSERT INTO f_results 
                                 ( event_id
                                  , competition_id
                                  , placement
                                  , team_id
                                  , team_id_str
                                  , gender_division
                                  , age_division
                                  , competition_division
                                  , source_url
                                  , source_name
                                  , source_file
                                  , notes
                                  )
                                 
                             SELECT     tmp.event_id
                                      , tmp.competition_id
                                      , tmp.placement
                                      , tm.team_id
                                      , tmp.team_id_str
                                      , tmp.gender_division
                                      , tmp.age_division
                                      , tmp.competition_division
                                      , tmp.source_url
                                      , tmp.source_name
                                      , tmp.source_file
                                      , tmp.notes
                                     
                             FROM tmp_results tmp
                             
                             LEFT JOIN d_teams tm
                                 ON tm.team_id_str = tmp.team_id_str
                             ;
                         ''')      

                #con.execute('DROP TABLE tmp_results;')    
     
                db_message = "Success updating table f_results!"
     
        except:
            db_message = "Fail updating table f_results!"
     
        print(db_message)  