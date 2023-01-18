---
title: "Self Project"
author: "Amit"
date: "15 7 2021"

---


Packeges 

library(ggplot2)
library(ggrepel)
library(dplyr)
library(tidyverse)
library(tidyr)
library(stars)
library(sf)
```


Data: 
```
covid
motor
motor_death_per_100000
death_airpollution
population
Death_people
```
---

```
## Arrange the dataset 
colnames(motor)[4] = "vehicles_per_1000"
colnames(motor_death_per_100000)[4] = "death_rate_road"

## Filter the dataset by year and remove extreme values
motor_death_2014 = motor_death_per_100000 %>%
  filter(Year == 2014) %>%
  arrange(Code)%>% 
  slice(36:231)%>%
select(Entity, death_rate_road, Code)
## Join 
all_motor = motor_death_2014 %>%
  left_join(motor, by = "Entity") %>%
  select(Entity, vehicles_per_1000, death_rate_road, Code.x
 ) %>%
  arrange(Entity
)%>%
  left_join(codes, by = c("Code.x" = "code" ))
## Plot
ggplot(all_motor, aes(x = all_motor$vehicles_per_1000, y = all_motor$death_rate_road)) +
         geom_point() + geom_smooth(color = "red") +
         geom_text_repel(aes(label = Entity)) + 
  ggtitle("Car density") +
  xlab("Amount of vehicles") + ylab("Death from car accident")
  
```
---
```
## Filter the dataset by year

deathemi_by_years = death_airpollution %>%
  filter(Year == 2014) %>%
  select(Entity, Air.pollution..total...deaths.per.100.000.)

## Filter the dataset by year 
pop = population %>%
  filter(Time == 2014) %>%
  select(Location, PopTotal, PopDensity)
## Join and remove extreme values
pop_airpollution = pop %>%
  left_join(deathemi_by_years, by = c("Location" = "Entity"))%>%
  arrange( Air.pollution..total...deaths.per.100.000.)%>%
  slice(1:179)

## Arrange the dataset 
colnames(pop_airpollution)[4] = "CO2.Total.Death"
pop_airpollution2 = pop_airpollution[-28,]
## Plot
ggplot(pop_airpol, aes(x = pop_airpol$PopDensity, y = pop_airpol$CO2.Total.Death)) +
         geom_point() + geom_smooth(color = "red") +
         geom_text_repel(aes(label = Location)) + 
  ggtitle("Density to CO2") +
  xlab("People density") + ylab("Death from CO2")
  
```
---
```
## Filter the dataset by year
death_world = Death_people %>%
  filter(Year == 2014) %>%
  left_join(pop, by = c("Entity" = "Location")) %>% ## Join 
 arrange(Entity)
   colnames(death_world)[4] = "Number of dead people" ## Arrange dataset 
death_world = death_world %>%
  select(Entity, `Number of dead people`, PopTotal, PopDensity)%>%
  arrange(`Number of dead people`)%>%
  slice(1:233) ## Remove extreme values
death_world2 = death_world[-69,]

## Plot
ggplot(death_world2, aes(x = death_world2$PopDensity, y = death_world2$`Number of dead people`)) +
         geom_point() + geom_smooth(color = "red") +
         geom_text_repel(aes(label = Entity)) + 
  ggtitle("Density To Total Death") +
  xlab("People density") + ylab("Total Death")

## Covarince test
cor.test(death_world2$PopDensity, death_world2$`Number of dead people`)



```
---
```
covid_day = readRDS("covid.rds")
covid_day$date = as.character(covid_day$date) ## Filter dataset by date
covid_day = covid_day[covid_day$date == "12/08/2020", ]
colnames(covid_day)[5] = "Covid.19.total.deaths" ## Arrange dataset
covid_day = covid_day %>%
  select(location, Covid.19.total.deaths, population, population_density)%>%
arrange(population_density)%>%
slice(1:180) ## Remove extreme values
covid_day2 = covid_day[-68,]

#Plot
ggplot(covid_day2, aes(x = covid_day2$population_density, y = covid_day2$Covid.19.total.deaths)) +
        
   geom_point() + geom_smooth(color = "red") +
         geom_text_repel(aes(label = location)) + 
  ggtitle("Density to Covid-19") +
  xlab("People density") + ylab("Death from Covid-19")

```


---

```

##Joining all tables
final_table = all_motor  %>%
  left_join(pop_airpollution, by = c("Entity" = "Location")) %>%
  left_join(covid_day2, by = c("Entity" = "location")) %>%
  left_join(death_world2, by = c("Entity" = "Entity")) 
  
final_table = final_table %>%
   select(population, population_density, vehicles_per_1000, death_rate_road, CO2.Total.Death, Covid.19.total.deaths,  `Number of dead people`)

head(final_table)



```



