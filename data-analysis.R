# Data Analysis

## load packages
library(tidyverse)

## grab the data for our analysis
sample <- read_csv("data/sample_data.csv")

glimpse(sample)

##Summarizing data with summarize
summarize(sample, avg_cells = mean(cells_per_ml))

##summarize() to get some sort of summary statistic
sample %>% 
  summarize(avg_cells = mean(cells_per_ml)) 

##group_by() to do the same thing but group by something
sample %>%
  group_by(env_group) %>%
  summarize(avg_cells = mean(cells_per_ml)) 

##filter() for subsetting data
sample %>%
  # subset samples only from the deep
  # calculate mean cell abundances
  filter(env_group == "Deep") %>%
  summarize(avg_cells = mean(cells_per_ml))

## mutate () for creating a new column in df
sample %>%
  #calculate a new column with TN:TP ratio
  mutate(tn_tp_ratio = total_nitrogen/total_phosphorus)

##select() to subset by entire columns
sample %>%
  select(-c(diss_org_carbon))

# Data Cleaning !!