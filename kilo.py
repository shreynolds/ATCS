import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def pick_color(team):
    if team in playoffTeams:
        return "green"
    else:
        return "red"

if __name__ == "__main__":
    playoffTeams = ["BOS", "LAD", "HOU", "MIL", "NYY", "OAK", "COL", "CHC", "CLE", "ATL"]
    stats = pd.read_csv("mlb_stats.csv")
    stats = stats[:30]
    plt.figure()
    data = stats.plot(x='Tm', y='R/G ▼', kind='bar', color = stats["Tm"].apply(pick_color))
    #  color citation: https://python-graph-gallery.com/3-control-color-of-barplots/
    plt.ylabel("Runs Per Game")
    plt.xlabel("Team")
    plt.title("Runs Per Game by MLB Team")
    plt.legend("")
    plt.show()

    plt.close('all')

