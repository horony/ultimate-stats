#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 15:09:58 2022

@author: lennart
"""

event_dict = {
    "euf_inv_2022_open": {
        "load_now" : 1
        , "competition": "euf_elite_invite"
        , "event": "euf_elite_invite_2022"
        , "round_no": 1
        , "matchups_page": "https://euf.ultimatecentral.com/e/elite-invite-2022/schedule/division/Open/stage/all/game_type/played?page="
        , "results_page": "https://euf.ultimatecentral.com/e/elite-invite-2022/standings/division/Open/stage/141127"
        , "gender_division": "open"
        , "competition_division": "club"
        , "age_division": "adult"           
        , "source_url": "https://euf.ultimatecentral.com/e/elite-invite-2022"
   },
   "euf_inv_2022_mixed": {
        "load_now" : 1
        , "competition": "euf_elite_invite"
        , "event": "euf_elite_invite_2022"
        , "round_no": 1
        , "matchups_page": "https://euf.ultimatecentral.com/e/elite-invite-2022/schedule/division/Mixed/stage/all/game_type/played?page="
        , "results_page": "https://euf.ultimatecentral.com/e/elite-invite-2022/standings/stage/141125/division/Mixed"
        , "gender_division": "mixed"
        , "competition_division": "club"
        , "age_division": "adult"           
        , "source_url": "https://euf.ultimatecentral.com/e/elite-invite-2022"
   },
   "euf_inv_2022_women": {
        "load_now" : 1
        , "competition": "euf_elite_invite"
        , "event": "euf_elite_invite_2022"
        , "round_no": 1
        , "matchups_page": "https://euf.ultimatecentral.com/e/elite-invite-2022/schedule/division/Women/stage/all/game_type/played?page="
        , "results_page": "https://euf.ultimatecentral.com/e/elite-invite-2022/standings/stage/141477/division/Women"
        , "gender_division": "women"
        , "competition_division": "club"
        , "age_division": "adult"           
        , "source_url": "https://euf.ultimatecentral.com/e/elite-invite-2022"
   },    
   "xeucf_2021_open": {
           "load_now" : 1
           , "competition": "eucf"
           , "event": "xeucf_2021"
           , "round_no": 1
           , "matchups_page": "https://euf.ultimatecentral.com/e/xeucf-2021/schedule/division/Men/stage/all/game_type/played?page="
           , "results_page": "https://euf.ultimatecentral.com/e/xeucf-2021/standings/stage/139261/division/Men"
           , "gender_division": "open"
           , "competition_division": "club"
           , "age_division": "adult"           
           , "source_url": "https://euf.ultimatecentral.com/e/xeucf-2021"
   },
   "xeucf_2021_women": {
           "load_now" : 0
           , "competition": "eucf"
           , "event": "eucf_2021"
           , "round_no": 1
           , "matchups_page": "https://euf.ultimatecentral.com/e/xeucf-2021/schedule/division/Women/stage/all/game_type/played?page="
           , "results_page": "https://euf.ultimatecentral.com/e/xeucf-2021/standings/stage/139258/division/Women"
           , "gender_division": "women"
           , "age_division": "adult"
           , "competition_division": "club"
           , "source_url": "https://euf.ultimatecentral.com/e/xeucf-2021"
    },
   "xeucf_2021_mixed": {
           "load_now" : 0
           , "competition": "eucf"
           , "event": "eucf_2021"
           , "round_no": 1
           , "matchups_page": "https://euf.ultimatecentral.com/e/xeucf-2021/schedule/division/Mixed/stage/all/game_type/played?page="
           , "results_page": "https://euf.ultimatecentral.com/e/xeucf-2021/standings/stage/139255/division/Mixed"
           , "gender_division": "mixed"
           , "age_division": "adult"
           , "competition_division": "club"
           , "source_url": "https://euf.ultimatecentral.com/e/xeucf-2021"
    },
   "eucf_2019_open": {
           "load_now" : 0
           , "competition": "eucf"
           , "event": "eucf_2019"
           , "round_no": 1
           , "matchups_page": "https://euf.ultimatecentral.com/e/eucf-2019/schedule/division/Men/stage/all/game_type/played?page="
           , "results_page": "https://euf.ultimatecentral.com/e/eucf-2019/standings/stage/132215/division/Men"
           , "gender_division": "open"
           , "competition_division": "club"
           , "age_division": "adult"           
           , "source_url": "https://euf.ultimatecentral.com/e/eucf-2019"
   },
   "eucf_2019_women": {
           "load_now" : 0
           , "competition": "eucf"
           , "event": "eucf_2019"
           , "round_no": 1
           , "matchups_page": "https://euf.ultimatecentral.com/e/eucf-2019/schedule/division/Women/stage/all/game_type/played?page="
           , "results_page": "https://euf.ultimatecentral.com/e/eucf-2019/standings/stage/132219/division/Women"
           , "gender_division": "women"
           , "age_division": "adult"
           , "competition_division": "club"
           , "source_url": "https://euf.ultimatecentral.com/e/eucf-2019"
    },
   "eucf_2019_mixed": {
           "load_now" : 1
           , "competition": "eucf"
           , "event": "eucf_2019"
           , "round_no": 1
           , "matchups_page": "https://euf.ultimatecentral.com/e/eucf-2019/schedule/division/Mixed/stage/all/game_type/played?page="
           , "results_page": "https://euf.ultimatecentral.com/e/eucf-2019/standings/stage/132217/division/Mixed"
           , "gender_division": "mixed"
           , "age_division": "adult"
           , "competition_division": "club"
           , "source_url": "https://euf.ultimatecentral.com/e/eucf-2019"
    },
   "euc_2019_open": {
           "load_now" : 1
           , "competition": "euc"
           , "event": "euc_2019"
           , "round_no": 1
           , "matchups_page": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019/schedule/division/Men/stage/all/game_type/played?page="
           , "results_page": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019/standings/stage/130655/division/Men"
           , "gender_division": "open"
           , "competition_division": "nationalteam"
           , "age_division": "adult"           
           , "source_url": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019"
   },
   "euc_2019_women": {
           "load_now" : 0
           , "competition": "euc"
           , "event": "euc_2019"
           , "round_no": 1
           , "matchups_page": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019/schedule/division/Women/stage/all/game_type/played?page="
           , "results_page": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019/standings/stage/130678/division/Women"
           , "gender_division": "women"
           , "age_division": "adult"
           , "competition_division": "nationalteam"
           , "source_url": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019"
    },
   "euc_2019_mixed": {
           "load_now" : 0
           , "competition": "euc"
           , "event": "euc_2019"
           , "round_no": 1
           , "matchups_page": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019/schedule/division/Mixed/stage/all/game_type/played?page="
           , "results_page": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019/standings/stage/130661/division/Mixed"
           , "gender_division": "mixed"
           , "age_division": "adult"
           , "competition_division": "nationalteam"
           , "source_url": "https://euc2019.ultimatecentral.com/en_ie/e/euc2019"
    }     
}
