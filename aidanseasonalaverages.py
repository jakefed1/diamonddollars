import pandas as pd
dollars_olyas_df = pd.read_csv("dollars_olyas.csv")


dollars_2015_df = dollars_olyas_df.loc[dollars_olyas_df['year.x'] == 2015]
dollars_2015_averages = dollars_2015_df.groupby(['player']).mean()
print(dollars_2015_averages)
dollars_2015_averages.to_csv('dollars_2015_averages.csv')

dollars_2016_df = dollars_olyas_df.loc[dollars_olyas_df['year.x'] == 2016]
dollars_2016_averages = dollars_2016_df.groupby(['player']).mean()
print(dollars_2016_averages)
dollars_2016_averages.to_csv('dollars_2016_averages.csv')

dollars_2017_df = dollars_olyas_df.loc[dollars_olyas_df['year.x'] == 2017]
dollars_2017_averages = dollars_2017_df.groupby(['player']).mean()
print(dollars_2017_averages)
dollars_2017_averages.to_csv('dollars_2017_averages.csv')

dollars_2018_df = dollars_olyas_df.loc[dollars_olyas_df['year.x'] == 2018]
dollars_2018_averages = dollars_2018_df.groupby(['player']).mean()
print(dollars_2018_averages)
dollars_2018_averages.to_csv('dollars_2018_averages.csv')

dollars_2019_df = dollars_olyas_df.loc[dollars_olyas_df['year.x'] == 2019]
dollars_2019_averages = dollars_2019_df.groupby(['player']).mean()
print(dollars_2019_averages)
dollars_2019_averages.to_csv('dollars_2019_averages.csv')

dollars_2020_df = dollars_olyas_df.loc[dollars_olyas_df['year.x'] == 2020]
dollars_2020_averages = dollars_2020_df.groupby(['player']).mean()
print(dollars_2020_averages)
dollars_2020_averages.to_csv('dollars_2020_averages.csv')