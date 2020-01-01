from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import collections
import time
import csv

def scrape_espn_nba(year):

    url_link = 'https://www.espn.com/nba/stats/player/_/season/' + str(year) + '/seasontype/2'

    csv_filename = 'NBA_reg_' + str(year-1) + '-' + str(year) + '.csv'

    driver = webdriver.Firefox()
    
    driver.get(url_link)

    # Assumes script is run at project repo
    csv_file = open('./data/'+csv_filename, 'w+', encoding = "utf8")

    writer = csv.writer(csv_file)
    writer.writerow(['PLAYER', 'Team', 'POS', 'GP', 'MIN', 'PTS','FGM', 'FGA', 'FG%', '3PM', '3PA', '3P%', \
                    'FTM', 'FTA', 'FT%', 'REB', 'AST', 'STL', 'BLK', 'TO', 'DD2', 'TD3', 'PER'])

    # To click on "Show More" button until all data in table is shown
    while True:
        try:
            button = driver.find_element_by_xpath('//*[@id="fittPageContainer"]/div[3]/div[1]/div/section/div/div[3]/div/a')
            button.click()
            time.sleep(5)
        except:
            break


    plyr_trs = driver.find_elements_by_xpath('//*[@id="fittPageContainer"]/div[3]/div[1]/div/section/div/div[3]/section/div[2]/table/tbody/tr')
    stats_trs = driver.find_elements_by_xpath('//*[@id="fittPageContainer"]/div[3]/div[1]/div/section/div/div[3]/section/div[2]/div/div[2]/table/tbody/tr')


    for i in range(len(plyr_trs)):
        # Initiate plyr_dict
        plyr_dict = collections.OrderedDict()

        # Table 1: Player name and Team
        ply = plyr_trs[i]
        
        Player = ply.find_element_by_xpath('.//td[2]/div/a').text
        Team = ply.find_element_by_xpath('.//td[2]/div/span').text

        # Table 2: Player Position and Stats
        stats = stats_trs[i]

        POS = stats.find_element_by_xpath('.//td[1]').text
        GP = stats.find_element_by_xpath('.//td[2]').text
        MIN = stats.find_element_by_xpath('.//td[3]').text
        PTS = stats.find_element_by_xpath('.//td[4]').text
        FGM = stats.find_element_by_xpath('.//td[5]').text
        FGA = stats.find_element_by_xpath('.//td[6]').text
        FGPer = stats.find_element_by_xpath('.//td[7]').text
        ThreePM = stats.find_element_by_xpath('.//td[8]').text
        ThreePA = stats.find_element_by_xpath('.//td[9]').text
        ThreePPer = stats.find_element_by_xpath('.//td[10]').text
        FTM = stats.find_element_by_xpath('.//td[11]').text
        FTA = stats.find_element_by_xpath('.//td[12]').text
        FTPer = stats.find_element_by_xpath('.//td[13]').text
        REB = stats.find_element_by_xpath('.//td[14]').text
        AST = stats.find_element_by_xpath('.//td[15]').text
        STL = stats.find_element_by_xpath('.//td[16]').text
        BLK = stats.find_element_by_xpath('.//td[17]').text
        TO = stats.find_element_by_xpath('.//td[18]').text
        DD2 = stats.find_element_by_xpath('.//td[19]').text
        TD3 = stats.find_element_by_xpath('.//td[20]').text
        PER = stats.find_element_by_xpath('.//td[21]').text

        # Store in ordered dictionary
        plyr_dict['Player'] = Player
        plyr_dict['Team'] = Team
        plyr_dict['POS'] = POS
        plyr_dict['GP'] = GP
        plyr_dict['MIN'] = MIN
        plyr_dict['PTS'] = PTS
        plyr_dict['FGM'] = FGM
        plyr_dict['FGA'] = FGA
        plyr_dict['FG%'] = FGPer
        plyr_dict['3PM'] = ThreePM
        plyr_dict['3PA'] = ThreePA
        plyr_dict['3P%'] = ThreePPer
        plyr_dict['FTM'] = FTM
        plyr_dict['FTA'] = FTA
        plyr_dict['FT%'] = FTPer
        plyr_dict['REB'] = REB
        plyr_dict['AST'] = AST
        plyr_dict['TO'] = TO
        plyr_dict['STL'] = STL
        plyr_dict['BLK'] = BLK
        plyr_dict['DD2'] = DD2
        plyr_dict['TD3'] = TD3
        plyr_dict['PER'] = PER

        # Write to csv
        writer.writerow(plyr_dict.values())

    csv_file.close()

    driver.close()

    print("Year " + str(year) + " scraping done!")