# nba_espn

# Analysis of NBA players from 2001/02 to 2018/19 seasons

This is my personal project on learning and applying Bayesian Statistics on NBA players data. The analysis is based on learnings from John Kruschke's book ["Doing Bayesian Data Analysis (2nd Edition)"](https://sites.google.com/site/doingbayesiandataanalysis/).

# Data

The data is from ESPN's NBA players stats data for different regular seasons. An example of the 2018/19 player stats can be found in the following url:

https://www.espn.com/nba/stats/player/_/season/2019/seasontype/2

Using the Selenium package with Firefox driver, the data was scraped for the regular seasons from 2001/02 to 2018/19. The scraped data can be found in this [folder](https://github.com/kfoofw/nba_espn/tree/master/data). 

# Motivations

NBA teams have seen a shift in their playstyles for many years. In the past, teams were built around the conventional hierarchy of backcourt guards and front court roles. However the current age of NBA places a premium on 3 point shooting, and also focus on the concept of "small-ball" line-ups. The stereotypical center with dominant post-moves is now a thing of the past; teams demand "big men" with either 3 point shooting abilities or excellent passing skills.

<p align = "center">
    <img src = "https://cdn.vox-cdn.com/thumbor/kEqrGTrAMuelHQTrAYQvNk7FWxk=/0x0:5472x3648/920x613/filters:focal(2259x0:3133x874):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/65765916/1184051870.jpg.0.jpg" width = 500>
</p>

On that premise, my motivations for this project is to explore the differences in the player statistics across the years. 

Based on the ESPN data, each player is assigned their positions based on conventional basketball positions:
- PG: Point Guard
- SG: Shooting Guard
- G: Guard (probably for players who can play both PG and SG)
- SF: Small Forward
- PF: Power Forward
- F: Forward (probably for players who can play both SF and PF)
- C: Center

This aspect of position labelling is the crux for the Bayesian Hierarchical (BH) modelling analysis with the basketball position integrated into the hierarchy. For this project, I will explore the following issues:  
- Understand the field goals for 3 points percentage (3P%) for different positions. 
    - Since each 3 point field goal is dichotomous (0 or 1), the BH model will utilise a series of Bernoulli variables as modelled by a Binomial distribution with N trials.
    - (Work in Progress)
- To see if 3 point percentages for "big men" roles have changed throughout the years. 
    - (In Future)
- Explore the points per game (PPG) for different positions and how they have changed across time.     - The Bayesian Hierarchical model will be using a negative binomial distribution for modelling PPG (given that Points per game is count data).
    - (In Future)

# Software

I used Python with Selenium (Firefox) for webscraping. The scraping scripts can be found here in [this folder](https://github.com/kfoofw/nba_espn/tree/master/scrape_scripts).

Analysis was done using R with the RJAGS package. The analysis scripts for generating the Markov Chain Monte Carlo simulations were adopted/modified from the [software](https://sites.google.com/site/doingbayesiandataanalysis/software-installation) that came with the "Doing Bayesian Data Analysis" book. 
- It is highly recommended to use the book as a guide for understanding RJAGs syntax.

