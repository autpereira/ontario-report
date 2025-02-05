# Data Analysis

## load packages
library(tidyverse)

## grab the data for our analysis

sample <- read_csv("data/sample_data.csv")

glimpse(sample)

##Summarizing data
summarize(sample, avg_cells = mean(cells_per_ml))

##the next lines pipes in the data into the command.... i don't like this style as much!
sample %>% 
  summarize(avg_cells = mean(cells_per_ml)) 

##do the same thing but group by something
sample %>%
  group_by(env_group) %>%
  summarize(avg_cells = mean(cells_per_ml)) 