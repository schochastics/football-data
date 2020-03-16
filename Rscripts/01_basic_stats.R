library(tidyverse)
#------------------------------------------------------------------------------#

res_files <- list.files("data/results",full.names = T)
col_spec <- cols(
  home = col_character(),
  away = col_character(),
  date = col_date(format = ""),
  gh = col_integer(),
  ga = col_integer(),
  full_time = col_character(),
  competition = col_character(),
  home_ident = col_character(),
  away_ident = col_character(),
  home_country = col_character(),
  away_country = col_character(),
  home_code = col_character(),
  away_code = col_character(),
  home_continent = col_character(),
  away_continent = col_character(),
  continent = col_character(),
  level = col_character()
)

games <- map_dfr(res_files,read_csv,col_types = col_spec) %>% arrange(date)

#------------------------------------------------------------------------------#
# basic stats examples----

# total number of games
nrow(games)

# games per competition
games %>% count(competition,sort = TRUE)

# games per continent
games %>% count(continent,sort = TRUE)

# games per team
games %>%
  select(home_ident,away_ident) %>%
  gather("location","team") %>%
  count(team,sort = TRUE)

# number of goals
sum(games$gh+games$ga)

# goals per game
sum(games$gh+games$ga)/nrow(games)

# most goals in a match (excluding extra time and penalties)
games %>%
  dplyr::filter(full_time=="F") %>%
  mutate(goals = gh+ga) %>%
  arrange(-goals) %>%
  select(home_ident,away_ident,date,gh,ga)

# goals per country per game (show top and bottom 5)
games %>%
  mutate(goals = gh+ga) %>%
  group_by(competition) %>%
  summarise(gpg = sum(goals)/n()) %>%
  arrange(-gpg) %>%
  map_dfr(.,function(x) rbind(head(x,5),tail(x,5))) %>%
  arrange(-gpg)

# goals per team
games %>%
  select(home_ident,away_ident,gh,ga) %>%
  gather("location","team",-gh,-ga) %>%
  mutate(scored = case_when(location=="home_ident" ~ gh,
                            location=="away_ident" ~ ga),
         conceded = case_when(location=="home_ident" ~ ga,
                              location=="away_ident" ~ gh)) %>%
  group_by(team) %>%
  summarise(goals_scored = sum(scored),goals_conceded = sum(conceded)) %>%
  arrange(-goals_scored)

# goals per team per game (more than 100 games played)
games %>%
  select(home_ident,away_ident,gh,ga) %>%
  gather("location","team",-gh,-ga) %>%
  mutate(scored = case_when(location=="home_ident" ~ gh,
                            location=="away_ident" ~ ga)) %>%
  group_by(team) %>%
  summarise(goals_scored = sum(scored)/n(),played = n()) %>%
  dplyr::filter(played>=100) %>%
  arrange(-goals_scored)

# most frequent results
games %>% count(gh,ga,sort = TRUE)

