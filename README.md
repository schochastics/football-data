**This repository is made available under the [Open Data Commons Attribution License](https://opendatacommons.org/licenses/by/1-0/index.html)**

# football-data

This repository contains some datasets for football (soccer). 

## Updates

(11/2024)
- Result data now contains all games until end of 2023 as a parquet file
- `data/goals_time` now includes 23 competitions 

## Football Results Dataset

`data/results` contains results of 1,237,935 football games in 207 top-tier domestic leagues and 
20 international tournaments (UEFA EuroLeague/ChampionsLeague,etc.) from
1888-2023. The data is provided as a parquet file.

### Codebook

| variable       | description                                                     |
|----------------|-----------------------------------------------------------------|
| home           | home team name (not necessarily unique)                         |
| away           | away team name (not necessarily unique)                         |
| date           | date of match                                                   |
| gh             | goals for home team (including extra time and penalties)        |
| ga             | goals for away team (including extra time and penalties)        |
| full_time      | "F"=game ended in 90', "E"=extra time, "P"=penalty shoot-out    |
| competition    | country name of league or name of international competition     |
| home_ident     | unique identifier of home team                                  |
| away_ident     | unique identifier of away team                                  |
| home_country   | country of home team                                            |
| away_country   | country of away team                                            |
| home_code      | country code of home team                                       |
| away_code      | country code of away team                                       |
| home_continent | continent of home team                                          |
| away_continent | continent of away team                                          |
| continent      | continent of competition                                        |
| level          | "national"= domestic league, "international"= international cup |

### Disclaimer

This dataset contains errors for older games where sources are not as reliable.
A big issue are teams that merge/split/dissolve over time, which (I think) I did
not resolve consistently over time.

I have gathered this dataset over the course of 10 years and put a lot of effort in
it (see [worldclubratings.com](worldclubratings.com)). If you use the data for any kind of project, please drop me a line
or open an issue in this repository. If you have any questions or requests,
please open an issue too.

## formations and lineups

The folder `data/formations` contains lineups and formations datasets 

## goals and times

The folder `data/goals_time` contains details about each scored goal (scorer,
time) in the Top 15 European Leagues (according to the UEFA 5 year rating 2004), the Champions League and Euro League, and
a few national cups.

## Links

[worldclubratings.com](http://worldclubratings.com/)

Similar datasets:  

- [European Soccer Database](https://www.kaggle.com/hugomathien/soccer) (Kaggle)
- [World Soccer](https://www.kaggle.com/sashchernuh/european-football)  (Kaggle)
- [International Football Results](https://www.kaggle.com/martj42/international-football-results-from-1872-to-2017) (Kaggle)
- [engsoccerdata](https://github.com/jalapic/engsoccerdata) (R package)
- [football-data.co.uk](http://football-data.co.uk/)


