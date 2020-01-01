from espn_nba_scraper import scrape_espn_nba

seasons_list = [x for x in range(2003, 2020)]

Up to 2018-2019 season
for i in seasons_list:
    scrape_espn_nba(i)


