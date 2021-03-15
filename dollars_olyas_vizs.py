import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import scipy as sp

dollars_olyas = pd.read_csv('dollars_olyas.csv')
print(dollars_olyas)

print(dollars_olyas[['game_score', 'our_metric', 'LYAS', 'OLYAS']].describe())
print(dollars_olyas[['game_score', 'OLYAS']].describe())

game_score_distribution = sns.histplot(data=dollars_olyas, x='game_score', kde=True)
plt.xlabel("Tango Game Score")
plt.ylabel("Frequency")
plt.title("Game score distribution")
plt.show()

olyas_distribution = sns.histplot(data=dollars_olyas, x='OLYAS', kde=True)
plt.xlabel("OLYAS")
plt.ylabel("Frequency")
plt.title("OLYAS distribution")
plt.show()

dollars_olyas_summary = pd.read_csv('dollars_olyas_summary.csv')
print(dollars_olyas_summary)

print(dollars_olyas_summary[['game_score', 'OLYAS', 'Barrel%', 'HardHit%', 'LA', 'Contact%', 'Zone%', 'Z-Swing%']].corr(method='pearson'))

barrelgamescore= sns.scatterplot(data=dollars_olyas_summary, x='Barrel%', y='game_score', s = 10)
plt.xlabel("Barrel%")
plt.ylabel("Game score")
plt.title("The impact of Barrel %")
plt.show()

barrelOLYAS= sns.scatterplot(data=dollars_olyas_summary, x='Barrel%', y='OLYAS', s = 10)
plt.xlabel("Barrel%")
plt.ylabel("OLYAS")
plt.title("The impact of Barrel %")
plt.show()