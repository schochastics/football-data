<img src="http://soccerverse.com/static/img/logo_text_color.png" width="300px">

# Football Results Dataset

`data/results` contains results of 1,078,214 football games in 207 top-tier domestic leagues and 
20 international tournaments (UEFA EuroLeague/ChampionsLeague,etc.) from 1888-2019. The files are 
split up by competition but all follow the same scheme.


## Codebook

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

## Rscipts

The folder `Rscripts` contains some R code with basic analyses which could get you going:

- `01_basic_stats.R`: very simple stats (number of games, goals, etc)
- `02_soccerverse.R`: some code for figures on soccerverse.com

# Disclaimer

This dataset definitely contains errors, especially for older games, where sources are not
as reliable. A big issue are teams that merge/split/dissolve over time, which (I think) I did
not resolve consistently over time.

I have gathered this dataset over the course of 8 years and put a lot of effort in
it (see [soccerverse.com](soccerverse.com)). If you use the data for any kind of project, please drop me a line
or ping me on [twitter](https://twitter.com/schochastics). 

**This repository is made available under the [Open Data Commons Attribution License](https://opendatacommons.org/licenses/by/1-0/index.html)**


# Links

[soccerverse.com](soccerverse.com)



