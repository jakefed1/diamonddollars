#So this file will contain all the code I used for the whole project, R and Python. All Python is commented.

#First I need to load the dataset and remove NAs from the dataset
dollars_lgyr100 <- read_csv(file = "diamonddollarslgyr100.csv")
dollars_lgyr100

dollars_lgyr100 <- 
  dollars_lgyr100 %>% 
  filter(!is.na(LA))

dollars_lgyr100 <-
  dollars_lgyr100 %>% 
  filter(!is.na(`O-Swing%`))

dollars_lgyr100 <-
  dollars_lgyr100 %>%
  filter(!is.na(`F-Strike%`)) 
 
dollars_lgyr100 <-
  dollars_lgyr100 %>%
  filter(!is.na(`O-Contact%`))
dollars_lgyr100
  

write_csv(dollars_lgyr100, "diamonddollarslgyr100.csv")
#Some Python code I used

#Here we are adjusting for opponent, league, and year.
#import pandas as pd
#import numpy as np
#import scipy as sp

#Load CSV as dataframe
#dollars2_df = pd.read_csv('diamonddollarslgyr100.csv')
#print(dollars2_df)

#Assign new column for AL and NL opponents
#conditions = [
    #(dollars2_df['opp'] == 'BOS'),
    #(dollars2_df['opp'] == 'NYY'),
    #(dollars2_df['opp'] == 'BAL'),
    #(dollars2_df['opp'] == 'TBR'),
    #(dollars2_df['opp'] == 'TOR'),
    #(dollars2_df['opp'] == 'MIN'),
    #(dollars2_df['opp'] == 'CHW'),
    #(dollars2_df['opp'] == 'DET'),
    #(dollars2_df['opp'] == 'CLE'),
    #(dollars2_df['opp'] == 'KCR'),
    #(dollars2_df['opp'] == 'SEA'),
    #(dollars2_df['opp'] == 'LAA'),
    #(dollars2_df['opp'] == 'OAK'),
    #(dollars2_df['opp'] == 'HOU'),
    #(dollars2_df['opp'] == 'TEX'),
    #(dollars2_df['opp'] == 'WSN'),
    #(dollars2_df['opp'] == 'NYM'),
    #(dollars2_df['opp'] == 'PHI'),
    #(dollars2_df['opp'] == 'MIA'),
    #(dollars2_df['opp'] == 'ATL'),
    #(dollars2_df['opp'] == 'PIT'),
    #(dollars2_df['opp'] == 'STL'),
    #(dollars2_df['opp'] == 'CIN'),
    #(dollars2_df['opp'] == 'MIL'),
    #(dollars2_df['opp'] == 'CHC'),
    #(dollars2_df['opp'] == 'SDP'),
    #(dollars2_df['opp'] == 'LAD'),
    #(dollars2_df['opp'] == 'COL'),
    #(dollars2_df['opp'] == 'SFG'),
    #(dollars2_df['opp'] == 'ARI')
#]
#values = ['AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL']
#dollars2_df['opp_league'] = np.select(conditions, values)
#print(dollars2_df.head(10))
#print(dollars2_df.sample(10))


#find the average for each league each year
#al_dollars2_df = dollars2_df.loc[dollars2_df['opp_league'] == 'AL']
#al_averages2 = al_dollars2_df.groupby(['year']).mean()
#print(al_averages2)
#al_averages2.to_csv('al_averages2.csv')


#nl_dollars2_df = dollars2_df.loc[dollars2_df['opp_league'] == 'NL']
#nl_averages2 = nl_dollars2_df.groupby(['year']).mean()
#print(nl_averages2)
#nl_averages2.to_csv('nl_averages2.csv')

#Then add these to multiplier master, apply adjustment in R

#Then I did some stuff in Excel

#Then I did some R

#This script combines my lgyrmultipliers spreadsheet and my pitcher game log dataset and applies the lgyrmultipliers

library(tidyverse)
multipliers <- read_csv(file = "lgyrmultiplier_master.csv")
multipliers

#I have to select only these columns because a few extra null columns come up when I load in the original spreadsheet
multipliers <- select(multipliers, year, opp_league, league_average, lgyr_multiplier)

dollars_lgyr100 <- read_csv(file = "diamonddollarslgyr100.csv")
dollars_lgyr100

#Create an opponent league column so I can join by opponent league
dollars_lgyr100 <-
  dollars_lgyr100 %>% 
  mutate(
    opp_league = case_when(
      opp %in% c('BOS', 'NYY', 'BAL', 'TOR', 'TBR', 'DET', 'CLE', 'KCR', 'CHW', 'MIN', 'SEA', 'OAK', 'HOU', 'LAA', 'TEX') ~ 'AL',
      !opp %in% c('BOS', 'NYY', 'BAL', 'TOR', 'TBR', 'DET', 'CLE', 'KCR', 'CHW', 'MIN', 'SEA', 'OAK', 'HOU', 'LAA', 'TEX') ~ 'NL'
    )
  )
dollars_lgyr100

#Join by opponent league... lets me put multipliers and game scores on the same sheet
#Make sure to filters so year.x = year.y...that's a duplicate column and it makes everything come up like 5 times
dollars_lgyr100_2 <-
  dollars_lgyr100 %>%
  full_join(multipliers, by="opp_league") %>% 
  filter(year.x == year.y)
dollars_lgyr100_2

#Create league year adjusted score (LYAS) which is the game score * the multiplier (adjustment). 
#Make sure when our_metric is less than 0 you multiply by 1/multiplier so we aren't penalizing pitchers
#pitchers in the negatives for pitching against good teams
#But this is going to result in means not being 100 as we're not scaling by the multiplier every time,
#as in a few instances we are scaling by 1/multiplier.
#So our average LYAS for each year within each league won't be 100, but it will be very close.
#Close enough that we are comfortable using it.
#To check the means, just run code very similar to my code in lines 53-63 in ddoppadj2.py
dollars_lgyr100_adjusted <-
  dollars_lgyr100_2 %>% 
  mutate(
    LYAS = case_when(
      our_metric >= 0 ~ ((our_metric*lgyr_multiplier)),
      our_metric < 0 ~ ((our_metric*(1/lgyr_multiplier)))
    )
  )
dollars_lgyr100_adjusted

#I have to now write the csv so I can work with it in Python.
write_csv(dollars_lgyr100_adjusted, "dollars_LYAS.csv")

#So now we have done the league year adjustment. Now we have to do the team adjustment.
#This will require running Python to find team means with the new file dollars_LYAS.csv,
#creating a new multiplier master, then applying those multipliers.

#Python

#Read the new file as a CSV
#dollars_LYAS_df = pd.read_csv('dollars_LYAS.csv')

#Find the average for each team each year (post league year adjustment)
#dollars2_2015_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2015]
#dollars2_2015_averages = dollars2_2015_df.groupby(['opp']).mean()
#print(dollars2_2015_averages)
#dollars2_2015_averages.to_csv('dollars2_2015_averages.csv')

#dollars2_2016_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2016]
#dollars2_2016_averages = dollars2_2016_df.groupby(['opp']).mean()
#print(dollars2_2016_averages)
#dollars2_2016_averages.to_csv('dollars2_2016_averages.csv')

#dollars2_2017_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2017]
#dollars2_2017_averages = dollars2_2017_df.groupby(['opp']).mean()
#print(dollars2_2017_averages)
#dollars2_2017_averages.to_csv('dollars2_2017_averages.csv')

#dollars2_2018_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2018]
#dollars2_2018_averages = dollars2_2018_df.groupby(['opp']).mean()
#print(dollars2_2018_averages)
#dollars2_2018_averages.to_csv('dollars2_2018_averages.csv')

#dollars2_2019_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2019]
#dollars2_2019_averages = dollars2_2019_df.groupby(['opp']).mean()
#print(dollars2_2019_averages)
#dollars2_2019_averages.to_csv('dollars2_2019_averages.csv')

#dollars2_2020_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2020]
#dollars2_2020_averages = dollars2_2020_df.groupby(['opp']).mean()
#print(dollars2_2020_averages)
#dollars2_2020_averages.to_csv('dollars2_2020_averages.csv')

#Then I did some work in Excel

#Ok so now we got our new spreadsheet and our new multiplier master

team_multipliers <- read_csv(file = "team_multiplier_master.csv")
team_multipliers

#Time to join the team multipliers and LYAS spreadsheets, make sure to filter so year.x = year,
#that'll eliminate all the quintuple or 6x counting stuff

dollars_olyas <-
  dollars_lgyr100_adjusted %>%
  full_join(team_multipliers, by="opp") %>% 
  filter((year.x == year))
dollars_olyas

#Time to use a case_when statement to make the adjustment, once again LYAS * multiplier for positive LYAS's,
#LYAS * 1/multiplier for negative LYAS's.

dollars_olyas <-
  dollars_olyas %>% 
  mutate(
    OLYAS = case_when(
      LYAS >= 0 ~ ((LYAS*multiplier)),
      LYAS < 0 ~ ((LYAS*(1/multiplier)))
    )
  )
dollars_olyas

write_csv(dollars_olyas, "dollars_olyas.csv")

#Taking just stuff that is important so we don't have this crazy enormous spreadsheet with lots of useless things
dollars_olyas_summary <-
  dollars_olyas %>% 
  select(player, date, year, team, opp, IP, H, ER, BB, SO, 'Barrel%', 'HardHit%', 'Zone%', 'Z-Swing%', LA, 'Contact%', game_score, LYAS, OLYAS, lgyr_multiplier, multiplier)
dollars_olyas_summary

write_csv(dollars_olyas_summary, "dollars_olyas_summary.csv")

#Standardize function
standardize <- function(x){
  mu <- mean(x, na.rm = TRUE)
  sigma <- sd(x, na.rm = TRUE)
  return( (x - mu)/sigma )
}

#Put a couple things in z scores for easier comparisons
dollars_olyas_summary_Z <-
  dollars_olyas_summary %>% 
  mutate(z_game_score = standardize(game_score)) %>% 
  mutate(z_LYAS = standardize(LYAS)) %>% 
  mutate(z_OLYAS = standardize(OLYAS))
dollars_olyas_summary_Z

write_csv(dollars_olyas_summary_Z, "dollars_olyas_summary_Z.csv")

#Best starts
dollars_olyas_best <-
  dollars_olyas_summary %>% 
  arrange(desc(OLYAS))
dollars_olyas_best

#Worst starts
dollars_olyas_worst <-
  dollars_olyas_summary %>% 
  arrange(OLYAS)
dollars_olyas_worst

#Biggest differences between OLYAS and game_score
dollars_discrepancies <-
  dollars_olyas_summary_Z %>% 
  mutate(discrepancy = z_OLYAS - z_game_score) %>% 
  arrange(desc(discrepancy))
dollars_discrepancies
write_csv(dollars_discrepancies, "dollars_discrepancies.csv")

#Graphing game_score vs OLYAS
regression <- lm(data = dollars_olyas, OLYAS ~ game_score)
regression
plot<-
  ggplot(data=dollars_olyas)+
  geom_point(mapping = aes(x = game_score , y = OLYAS), col = "red", alpha = 0.2, size = 0.2) +
  geom_abline(intercept = -22.260, slope = 2.383, col = "blue", size = 1) +
  labs(
    x="game_score",
    y="OLYAS",
    title = "Tango's stat vs our stat",
    subtitle = "r = 0.705, R-squared = 0.497" ) +
  theme_bw()
plot
summary(regression)
summarize(dollars_olyas, correlation = cor(game_score, OLYAS))

#More Python graphing
#import numpy as np
#import pandas as pd
#import seaborn as sns
#import matplotlib.pyplot as plt
#import scipy as sp

#dollars_olyas = pd.read_csv('dollars_olyas.csv')
#print(dollars_olyas)

#print(dollars_olyas[['game_score', 'our_metric', 'LYAS', 'OLYAS']].describe())
#print(dollars_olyas[['game_score', 'OLYAS']].describe())

#game_score_distribution = sns.histplot(data=dollars_olyas, x='game_score', kde=True)
#plt.xlabel("Tango Game Score")
#plt.ylabel("Frequency")
#plt.title("Game score distribution")
#plt.show()

#olyas_distribution = sns.histplot(data=dollars_olyas, x='OLYAS', kde=True)
#plt.xlabel("OLYAS")
#plt.ylabel("Frequency")
#plt.title("OLYAS distribution")
#plt.show()

#dollars_olyas_summary = pd.read_csv('dollars_olyas_summary.csv')
#print(dollars_olyas_summary)

#print(dollars_olyas_summary[['game_score', 'OLYAS', 'Barrel%', 'HardHit%', 'LA', 'Contact%', 'Zone%', 'Z-Swing%']].corr(method='pearson'))

#barrelgamescore= sns.scatterplot(data=dollars_olyas_summary, x='Barrel%', y='game_score', s = 10)
#plt.xlabel("Barrel%")
#plt.ylabel("Game score")
#plt.title("The impact of Barrel %")
#plt.show()

#barrelOLYAS= sns.scatterplot(data=dollars_olyas_summary, x='Barrel%', y='OLYAS', s = 10)
#plt.xlabel("Barrel%")
#plt.ylabel("OLYAS")
#plt.title("The impact of Barrel %")
#plt.show()