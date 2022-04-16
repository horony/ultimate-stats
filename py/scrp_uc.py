#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 3 19:54:45 2022

@author: lennart
"""

from bs4 import BeautifulSoup
import requests
from datetime import datetime, timedelta
import pandas as pd
import re
import sys 
import numpy as np

def buildIdentifierStr(string_input, gender, comp, age):
    string_input = re.sub(r'[^a-zA-Z0-9]+', '', string_input)
    string_input = string_input.lower()
    
    if gender == 'open' or gender == 'mens':
        string_input = string_input+'_o'
    elif gender == 'women':
        string_input = string_input+'_w'
    elif gender == 'mixed':
        string_input = string_input+'_x'         
    
    if comp == 'club':
        string_input = string_input+''
    elif comp == 'college':
        string_input = string_input+'_clg'
    elif comp == 'nationalteam':
        string_input = string_input+'_nt'        
    elif comp == 'pro':
        string_input = string_input+'_pro'     

    if age == 'adult':
        string_input = string_input+''
    elif age == 'masters':
        string_input = string_input+'_m'
    elif age == 'u24':
        string_input = string_input+'_u24'        
    elif age == 'u23':
        string_input = string_input+'_u23'
    elif age == 'u20':
        string_input = string_input+'_u20'  
        
    return string_input

def buildIdentifierLocation(string_input):
    string_input = re.sub(r'[^a-zA-Z0-9]+', '', string_input)
    string_input = string_input.lower()  
     
    return string_input

def getParentText(parent):
    return ''.join(parent.find_all(text=True, recursive=False)).strip()

def buildDateTime(date, time):
    date = date.split(', ')[1]
    date = datetime.strptime(date, '%d %b %Y')
    
    hours = int(time.split(':')[0])
    minutes = int(time.split(':')[1])
    
    new_datetime = date + timedelta(hours=hours, minutes=minutes)
    
    return new_datetime


# import the custom database function
from db_insert_event_results import DBinsertResult

# import dictionary with website plus metainfo that are going to be scraped
from scrp_uc_input_data import event_dict

# interate over dictionary
for d, di in event_dict.items():
    print('\n Current dict:', d)
    
    if (di['load_now'] == 1):
        
        """
        SCRAPING RESULTS
        
        """
        
        print('\n Starting to scrape results...')

        page_to_scrape = di['results_page']
        
        r  = requests.get(page_to_scrape)
        data = r.text
        soup = BeautifulSoup(data, 'html.parser')
        
        results_found = soup.find_all("div", {"class": "striped-block clearfix"})
        
        df_results = pd.DataFrame(columns=[
                                            'event_id'
                                            , 'competition_id'
                                            , 'placement'
                                            , 'name_display'
                                            , 'team_id_str'
                                            , 'notes'
                                            , 'gender_division'
                                            , 'age_division'
                                            , 'competition_division'
                                            , 'source_name'
                                            , 'source_file'
                                            , 'source_url'
                                            ])
        df_results = df_results.reset_index(drop=True)
        
        # interate and parse all results found
        for elem in results_found:
            name_display = elem.find("a", {"class": "plain-link"}).getText().strip()
            
            team_id_str = buildIdentifierStr(name_display, di['gender_division'], di['competition_division'], di['age_division'])
            
            placement_raw = elem.find("span", {"class": "badge"}).getText()
            placement = int(re.sub("[^0-9]", "", placement_raw.split(' ')[0]))
            
            if "contending" in placement_raw.lower():
                notes = 'Shared placement'
            else:
                notes = None
            
            current_result_data = [[placement, name_display, team_id_str, notes]]
            df_current_results = pd.DataFrame(current_result_data, columns=['placement', 'name_display', 'team_id_str', 'notes'])
            df_current_results = df_current_results.reset_index(drop=True)

                    
            df_results = pd.concat([df_results, df_current_results], sort=True)
            
        df_results = df_results.assign(event_id=di['event']
                                       , competition_id=di['competition']
                                       , gender_division=di['gender_division']
                                       , age_division=di['age_division']
                                       , competition_division=di['competition_division']
                                       , source_name = 'Ultimate Central'
                                       , source_url = di['source_url']
                                       , source_file = None
                                       )

        print(df_results.head(3))
        print('Found', len(df_results.index), 'results')
        
        DBinsertResult(df_results, 'team_id_str')
        #unique_teams =  df_results['team_id_str']
                  
        """
        SCRAPING MATCHUPS
        
        """        
        
        print('\n Starting to scrape matchups...')
        
        # intitialize target dataframe        
        df_matchups = pd.DataFrame(columns=[
                                      'round_no'
                                    , 'event_id'
                                    , 'competition_id'
                                    , 'start_year'
                                    , 'start_dt'
                                    , 'start_ts'
                                    , 'home_team_id_str'
                                    , 'home_team_score'
                                    , 'home_team_spirit'
                                    , 'home_team_point_diff'
                                    , 'away_team_id_str'
                                    , 'away_team_score'
                                    , 'away_team_spirit'
                                    , 'away_team_point_diff'
                                    , 'point_diff'
                                    , 'is_universe_game'
                                    , 'is_draw'
                                    , 'has_spirit_scores'
                                    , 'location_name'
                                    , 'field_id'
                                    , 'gender_division'
                                    , 'age_division'
                                    , 'competition_division'
                                    , 'source_name'
                                    , 'source_url'
                                    , 'source_file'
                                    ])
        # interate over all sites with matchups found
        current_page = 1
        page_to_scrape = di['matchups_page']

        while current_page != 0:
            
            url = page_to_scrape + str(current_page)
            print(url)
            
            print('Scraping page', str(current_page))
            
            #header = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            
            r  = requests.get(url)
            print(r)
            data = r.text
            #print(data)
            soup = BeautifulSoup(data, 'html.parser')
            #print(soup)
            
            # check if final page ist found
            active_nav_site = soup.find("ul", {"class": "nav-pager align-left"})
            active_nav_site = active_nav_site.find("a", {"class": "selected"}).text
            
            if int(active_nav_site) != current_page:
                print("No more matchups found")
                current_page = 0
                
            else:
                matchups_found = soup.find_all("div", {"class": "game-list-item"})
                
                # interate and parse all matchups found on page
                for elem in matchups_found:
                                
                    matchup_datetime_and_place = elem.find_all("div", {"class": "clearfix"}) 
                    
                    # get datetime and year of current matchup
                    
                    try:
                        matchup_time = matchup_datetime_and_place[0].find("div", {"class": "small push-right"}).getText().strip()
                        matchup_date = matchup_datetime_and_place[0].find("span", {"class": "push-left"}).getText()
                        matchup_datetime = buildDateTime(matchup_date, matchup_time)
        
                    except:
                        start_ts = None
                        start_dt = None
                        start_year = None
                        
                    else:
                        matchup_time = matchup_datetime_and_place[0].find("div", {"class": "small push-right"}).getText().strip()
                        matchup_date = matchup_datetime_and_place[0].find("span", {"class": "push-left"}).getText()
                        start_ts = buildDateTime(matchup_date, matchup_time)   
                        start_dt = start_ts.date()
                        start_year = start_ts.year
                    
                    # get location and field of current matchup
                    
                    try:
                        matchup_location = matchup_datetime_and_place[1].find("a", {"class": "plain-link"}).getText()
                    except:
                        matchup_location = None
                        location_name = None
                    else:
                        matchup_location = matchup_datetime_and_place[1].find("a", {"class": "plain-link"}).getText()
                        location_name = buildIdentifierLocation(matchup_location)
                    
                    try:
                        matchup_field = getParentText(matchup_datetime_and_place[1].find("span", {"class": "push-left"}))
                    except:
                        matchup_field = None
                        field_id = None
                    else:
                        matchup_field = getParentText(matchup_datetime_and_place[1].find("span", {"class": "push-left"}))
                        field_id = di['event'] + '_r' +  str(di['round_no']) + '_' + location_name + '_' + buildIdentifierLocation(matchup_field)
                                
                    # get teams of current matchup
                    
                    matchup_teams = elem.find_all("div", {"class": "schedule-team-name"})

                    home_team_name = getParentText(matchup_teams[0].find("a", {"class": "plain-link"}))
                    home_team_id_str = buildIdentifierStr(home_team_name, di['gender_division'], di['competition_division'], di['age_division'])

                    away_team_name = getParentText(matchup_teams[1].find("a", {"class": "plain-link"}))
                    away_team_id_str = buildIdentifierStr(away_team_name, di['gender_division'], di['competition_division'], di['age_division'])        
                    
                    # get scores of current matchup
        
                    scores = elem.find_all("div", {"class": "score"})
                    try:
                        home_team_score = int(scores[0].text.strip())
                    except:
                        home_team_score = None
                    else:
                        home_team_score = int(scores[0].text.strip())
        
                    try:
                        away_team_score = int(scores[1].text.strip())
                    except:
                        away_team_score = None
                    else:
                        away_team_score = int(scores[1].text.strip())
                                   
                    # get spirit scores of current matchup
                    
                    spirits = elem.find_all("div", {"class": "schedule-score-box-game-result"})           
                    try:
                        home_team_spirit = int(spirits[0].text.strip())
                    except:
                        home_team_spirit = None
                    else:
                        home_team_spirit = int(spirits[0].text.strip())
        
                    try:
                        away_team_spirit = int(spirits[1].text.strip())
                    except:
                        away_team_spirit = None
                    else:
                        away_team_spirit = int(spirits[1].text.strip())
                    
                    current_matchup_data = [[start_year
                                             , start_dt, start_ts
                                             , home_team_id_str
                                             , home_team_score
                                             , home_team_spirit
                                             , away_team_id_str
                                             , away_team_score
                                             , away_team_spirit
                                             , location_name
                                             , field_id
                                             ]]
                    
                    df_current_matchup = pd.DataFrame(current_matchup_data, columns=['start_year'
                                                                                      , 'start_dt'
                                                                                      , 'start_ts'
                                                                                      , 'home_team_id_str'
                                                                                      , 'home_team_score'
                                                                                      , 'home_team_spirit'
                                                                                      , 'away_team_id_str'
                                                                                      , 'away_team_score'
                                                                                      , 'away_team_spirit'
                                                                                      , 'location_name'
                                                                                      , 'field_id'
                                                                                      ])
                    
                    df_matchups = pd.concat([df_matchups, df_current_matchup], sort=True)       
        
                current_page = current_page + 1
        
        
        df_matchups = df_matchups.dropna(subset=['home_team_score', 'away_team_score', 'home_team_id_str', 'away_team_id_str'])
        
        # calculate different column values
        
        # point differentials
        df_matchups['home_team_point_diff'] = df_matchups['home_team_score'] - df_matchups['away_team_score']
        df_matchups['away_team_point_diff'] = df_matchups['away_team_score'] - df_matchups['home_team_score']
        df_matchups['point_diff'] = abs(df_matchups['home_team_point_diff'])
        df_matchups['point_diff_factor'] = np.where(df_matchups["home_team_score"] > df_matchups["away_team_score"], df_matchups["home_team_score"], df_matchups["away_team_score"]) / np.where(df_matchups["home_team_score"] < df_matchups["away_team_score"], df_matchups["home_team_score"], df_matchups["away_team_score"])
        
        # was it a universe points point?
        df_matchups.loc[(df_matchups['point_diff'] == 1) & ((df_matchups['home_team_score'] + df_matchups['away_team_score']) == 29), 'is_universe_game'] = 1
        df_matchups['is_universe_game'] = df_matchups['is_universe_game'].apply(lambda x: 1 if x == 1 else 0)
        
        # has the game spirit scores?
        df_matchups.loc[(df_matchups['home_team_spirit'] > 0) & (df_matchups['away_team_spirit'] > 0), 'has_spirit_scores'] = 1
        df_matchups['has_spirit_scores'] = df_matchups['has_spirit_scores'].apply(lambda x: 1 if x == 1 else 0)
      
        # was it a draw?
        df_matchups['is_draw'] = df_matchups['point_diff'].apply(lambda x: 1 if x == 0 else 0)
        
        # assign constant column values
        df_matchups = df_matchups.assign(   round_no = di['round_no']
                                            , event_id = di['event']
                                            , competition_id = di['competition']
                                            , gender_division = di['gender_division']
                                            , age_division = di['age_division']
                                            , competition_division = di['competition_division']
                                            , source_file = None
                                            , source_name = 'Ultimate Central'
                                            , source_url = di['source_url']
                                         )
        
        print(df_matchups.head(3))
        print('Found', len(df_matchups.index), 'matches')
        
    else:
        print('No scraping command for this dict found')
    
    

