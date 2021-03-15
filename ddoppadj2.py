#Diamond dollars opponent adjustment
#The only difference between the second set of files and the first set of files
# is that in the second set the average real_OA_JAME is 100 for each league in each year
# instead of 100 for all starts across 5 years
# So basically instead of adjusting for just opponent and league we are adjusting for opponent, league, and year

#Here we are adjusting for opponent, league, and year.
import pandas as pd
import numpy as np
import scipy as sp

#Load CSV as dataframe
dollars2_df = pd.read_csv('diamonddollarslgyr100.csv')
print(dollars2_df)

#Assign new column for AL and NL opponents
conditions = [
    (dollars2_df['opp'] == 'BOS'),
    (dollars2_df['opp'] == 'NYY'),
    (dollars2_df['opp'] == 'BAL'),
    (dollars2_df['opp'] == 'TBR'),
    (dollars2_df['opp'] == 'TOR'),
    (dollars2_df['opp'] == 'MIN'),
    (dollars2_df['opp'] == 'CHW'),
    (dollars2_df['opp'] == 'DET'),
    (dollars2_df['opp'] == 'CLE'),
    (dollars2_df['opp'] == 'KCR'),
    (dollars2_df['opp'] == 'SEA'),
    (dollars2_df['opp'] == 'LAA'),
    (dollars2_df['opp'] == 'OAK'),
    (dollars2_df['opp'] == 'HOU'),
    (dollars2_df['opp'] == 'TEX'),
    (dollars2_df['opp'] == 'WSN'),
    (dollars2_df['opp'] == 'NYM'),
    (dollars2_df['opp'] == 'PHI'),
    (dollars2_df['opp'] == 'MIA'),
    (dollars2_df['opp'] == 'ATL'),
    (dollars2_df['opp'] == 'PIT'),
    (dollars2_df['opp'] == 'STL'),
    (dollars2_df['opp'] == 'CIN'),
    (dollars2_df['opp'] == 'MIL'),
    (dollars2_df['opp'] == 'CHC'),
    (dollars2_df['opp'] == 'SDP'),
    (dollars2_df['opp'] == 'LAD'),
    (dollars2_df['opp'] == 'COL'),
    (dollars2_df['opp'] == 'SFG'),
    (dollars2_df['opp'] == 'ARI')
]
values = ['AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'AL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL', 'NL']
dollars2_df['opp_league'] = np.select(conditions, values)
print(dollars2_df.head(10))
print(dollars2_df.sample(10))


#find the average for each league each year
al_dollars2_df = dollars2_df.loc[dollars2_df['opp_league'] == 'AL']
al_averages2 = al_dollars2_df.groupby(['year']).mean()
print(al_averages2)
al_averages2.to_csv('al_averages2.csv')


nl_dollars2_df = dollars2_df.loc[dollars2_df['opp_league'] == 'NL']
nl_averages2 = nl_dollars2_df.groupby(['year']).mean()
print(nl_averages2)
nl_averages2.to_csv('nl_averages2.csv')

#Then add these to multiplier master, apply adjustment in R

#Read the new file as a CSV
import pandas as pd
dollars_LYAS_df = pd.read_csv('dollars_LYAS.csv')

#Find the average for each team each year (post league year adjustment)
dollars2_2015_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2015]
dollars2_2015_averages = dollars2_2015_df.groupby(['opp']).mean()
print(dollars2_2015_averages)
dollars2_2015_averages.to_csv('dollars2_2015_averages.csv')

dollars2_2016_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2016]
dollars2_2016_averages = dollars2_2016_df.groupby(['opp']).mean()
print(dollars2_2016_averages)
dollars2_2016_averages.to_csv('dollars2_2016_averages.csv')

dollars2_2017_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2017]
dollars2_2017_averages = dollars2_2017_df.groupby(['opp']).mean()
print(dollars2_2017_averages)
dollars2_2017_averages.to_csv('dollars2_2017_averages.csv')

dollars2_2018_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2018]
dollars2_2018_averages = dollars2_2018_df.groupby(['opp']).mean()
print(dollars2_2018_averages)
dollars2_2018_averages.to_csv('dollars2_2018_averages.csv')

dollars2_2019_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2019]
dollars2_2019_averages = dollars2_2019_df.groupby(['opp']).mean()
print(dollars2_2019_averages)
dollars2_2019_averages.to_csv('dollars2_2019_averages.csv')

dollars2_2020_df = dollars_LYAS_df.loc[dollars_LYAS_df['year.x'] == 2020]
dollars2_2020_averages = dollars2_2020_df.groupby(['opp']).mean()
print(dollars2_2020_averages)
dollars2_2020_averages.to_csv('dollars2_2020_averages.csv')

#The rest was done in R and Excel
