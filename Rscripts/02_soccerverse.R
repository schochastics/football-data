library(tidyverse)
library(lubridate)
library(ggthemes)
library(hrbrthemes)

pal <- c("#2D4571","#AB8339","#AA3939","#AAA639","#061839","#553700")
uefa.col <- rgb(70,130,180,maxColorValue = 255)
conmebol.col <- rgb(143,188,143,maxColorValue = 255)
concacaf.col <- rgb(219,112,147,maxColorValue = 255)
caf.col <- rgb(222,184,135,maxColorValue = 255)
afc.col <- rgb(255,182,193,maxColorValue = 255)
ofc.col <- rgb(255,215,0,maxColorValue = 255)

#Global Home Field Advantage ----
games %>%
  group_by(year = year(date)) %>%
  dplyr::summarise(home=sum(gh>ga)/n(),
                   away=sum(ga>gh)/n(),
                   draw=sum(ga==gh)/n()) %>%
  gather(var,fraction,home:draw) %>%
  mutate(var=factor(var,levels=c("home","draw","away"))) %>%
  ggplot(aes(x=year,y=fraction,col=var))+
  geom_point(alpha=0.5,pch=19,size=2,stroke=0)+
  geom_smooth(method="loess",se=F)+
  scale_color_manual(values = c("#2D4571","#AB8339","#AA3939"),name="")+
  labs(title="Global home-field advantage",
       subtitle=paste("based on",nrow(games),
                      "games from 1888 to 2018"),
       x="Year",y="Percentage of home wins",caption="soccerverse.com")+
  scale_x_continuous(breaks = c(1890,1920,1950,1980,2010))+
  scale_y_percent()+
  theme_ipsum_rc(plot_margin = margin(10, 10, 10, 10))+
  theme(panel.grid.minor = element_blank(),
        legend.position="bottom",
        text = element_text(size=16))

# Average home/away goals  ----
games %>%
  group_by(year = year(date)) %>%
  dplyr::summarise(home=sum(gh)/n(),
                   away=sum(ga)/n(),
                   all=sum(ga+gh)/n()) %>%
  gather(var,fraction,home:away) %>%
  mutate(var=factor(var,levels=c("home","away","all"))) %>%
  ggplot(aes(x=year,y=fraction,col=var))+
  geom_point(alpha=0.5,pch=19,size=2,stroke=0)+
  geom_smooth(method="loess",se=F)+
  scale_color_manual(values = c("#2D4571","#AB8339","#AA3939"),name="")+
  labs(title="Average home/away goals per year ",
       subtitle=paste("based on",nrow(games),
                      "games from 1888 to 2018"),
       x="Year",y="Goals per game",caption="soccerverse.com")+
  scale_x_continuous(breaks = c(1890,1920,1950,1980,2010))+
  # scale_y_percent()+
  theme_ipsum_rc(plot_margin = margin(10, 10, 10, 10))+
  theme(panel.grid.minor = element_blank(),
        legend.position="bottom",
        text = element_text(size=16))

# HFA in big five ----
games %>%
  dplyr::filter(level=="national",continent=="Europe") %>%
  group_by(year=year(date),competition) %>%
  dplyr::summarise(home=sum(gh>ga)/n(),away=sum(ga>gh)/n(),draw=sum(ga==gh)/n()) %>%
  dplyr::filter(competition%in%c("germany","england","france","italy","spain")) %>%
  mutate(competition=recode(competition,england="EPL",
                        france="Ligue 1",germany="Bundesliga",italy="Serie A",spain="La Liga")) %>%
  gather(var,fraction,home:draw) %>%
  mutate(var=recode(var,home="home wins",away="away wins",draw="draws")) %>%
  mutate(var=factor(var,levels=c("home wins","away wins","draws"))) %>%
  ggplot(aes(x=year,y=fraction,col=competition,group=competition))+
  geom_point(alpha=0.25,pch=19,size=2,stroke=0)+
  geom_smooth(method="loess",se=F)+
  scale_color_manual(values = c("#2D4571","#AB8339","#AA3939","#AAA639","#061839","#553700"),name="")+
  scale_y_percent(limits=c(0,0.8))+
  scale_x_continuous(breaks=c(1890,1930,1970,2010))+
  theme_ipsum_rc(plot_margin = margin(10, 10, 10, 10))+
  theme(panel.grid.minor = element_blank(),
        legend.position="bottom",
        text = element_text(size=12))+
  labs(title="Home-field advantage in the Big Five",
       subtitle="Percentage of home wins, away wins and draws over time",
       caption="soccerverse.com",
       x="Year",y="Percentage")+
  guides(color=guide_legend(nrow=1))+
  facet_wrap(~var)

# best/worst home teams ----
games %>%
  group_by(home_ident) %>%
  dplyr::summarise(hwins=sum(gh>ga)/n(),games=n()) %>%
  dplyr::filter(games>99) %>%
  arrange(-hwins) %>%
  .[c(1:5,(nrow(.)-4):nrow(.)),] %>%
  ggplot(aes(x=reorder(home_ident,hwins),y=hwins))+
  geom_col(fill="#2D4571")+
  geom_hline(yintercept = c(0.2,0.4,0.6,0.8),col="white",size=0.2)+
  geom_text(aes(label=home_ident,
                y=ifelse(hwins>0.5,0.01,hwins+0.01)),
            hjust=0,col="#AB8339",size=4)+
  theme_ipsum_rc(plot_margin = margin(10, 10, 10, 10),grid = FALSE)+
  theme(text = element_text(size=14),axis.text.y = element_blank())+
  scale_y_percent()+
  labs(title="Top 5/Bottom 5 home win percentages of clubs",
       subtitle="Only clubs with more than 100 home matches considered",
       x="",y="Percentage",caption="soccerverse.com")+
  coord_flip()


# most frequent results -----
games %>%
  select(competition,gh,ga) %>%
  group_by(gh,ga) %>%
  dplyr::summarise(count=n()) %>%
  ungroup() %>%
  mutate(hfa=if_else(gh>ga,"home",if_else(ga>gh,"away","draw"))) %>%
  mutate(hfa=factor(hfa,levels=c("home","draw","away"))) %>%
  unite(result,c(gh,ga),sep=":") %>%
  top_n(20,count) %>%
  ggplot(aes(x=reorder(result,count),y=count,fill=hfa))+geom_col()+
  scale_fill_manual(values = c("#2D4571","#AB8339","#AA3939"),name="")+
  theme_ipsum_rc(grid=FALSE,plot_margin = margin(10, 10, 10, 10))+
  theme(axis.text.x = element_text(),
        legend.position = c(0.8,0.05),
        legend.direction = "horizontal")+
  geom_hline(yintercept = c(0,25000,50000,75000,100000),col="white")+
  scale_y_continuous(breaks=c(0,25000,50000,75000,100000))+
  coord_flip()+
  labs(x="",y="Number of games",caption="soccerverse.com",
       title="Most frequent results of football matches",
       subtitle=paste("based on", nrow(games),
                      "games from 1888 to 2018"))

#goals per year ----
games %>%
  group_by(year=year(date)) %>%
  dplyr::summarise(goals=sum(ga+gh)/n()) %>%
  ggplot(aes(x=year,y=goals))+
  geom_line(col="#2D4571")+
  labs(title="Average number of goals per game over time",
       subtitle="global average per year from 1888 to 2018",
       x="Year",y="Goals per game",caption="soccerverse.com")+
  scale_x_continuous(breaks = c(1890,1920,1950,1980,2010))+
  theme_ipsum_rc(plot_margin = margin(10, 10, 10, 10))+
  theme(panel.grid.minor = element_blank(),
        legend.position="bottom",
        text = element_text(size=16))


# result heatmap ---------
home <- games %>%
  mutate(gh = ifelse(gh > 7, 7, gh)) %>%
  group_by(gh) %>%
  dplyr::summarise(count = n() / nrow(games)) %>%
  mutate(ga = 8, count = count / max(count))

away <- games %>%
  mutate(ga = ifelse(ga > 7, 7, ga)) %>%
  group_by(ga) %>%
  dplyr::summarise(count = n() / nrow(games)) %>%
  mutate(gh = 8, count = count / max(count))

games %>%
  mutate(gh=ifelse(gh>7,7,gh),ga=ifelse(ga>7,7,ga)) %>%
  group_by(gh,ga) %>%
  dplyr::summarise(count=n()) %>%
  ungroup() %>%
  mutate(count=count/sum(count)) %>%
  ggplot(aes(ga,gh))+geom_tile(aes(fill=count),width=0.8,height=0.8)+
  geom_text(aes(label = ifelse(count>=0.0001,sprintf("%1.2f%%", 100*count),"<0.01%"),
                col=ifelse(count>0.03,"white","black")),
            family="Roboto Condensed",size=3)+
  scale_fill_gradient(low="#ADC6F5",high="#2D4571")+
  geom_rect(data=home,aes(xmin=ga-0.5,xmax=ga-0.5+count,ymin=gh-0.4,ymax=gh+0.4))+
  geom_rect(data=away,aes(xmin=ga-0.4,xmax=ga+0.4,ymin=gh-0.5,ymax=gh-0.5+count))+
  scale_color_manual(values=c("black","white"))+
  scale_y_reverse(breaks=c(0:7),labels =c(0:6,"7+"))+
  scale_x_continuous(breaks=c(0:7),labels =c(0:6,"7+") ,position="top")+
  theme_ipsum_rc(grid=F,plot_margin = margin(10, 10, 10, 10),
                 axis_title_just = "bt")+
  theme(legend.position = "none")+
  labs(x="Goals for away team",y="Goals for home team",
       title="Frequencies of football results",
       subtitle=paste("based on",nrow(games),
                      "games from 1888 to 2018"),
       caption="soccerverse.com")
