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

#skip = N will take the colnames from the N+1th row
taxa_dirty <- read_csv("data/taxon_abundance.csv", skip=2)

taxon_clean <- 
  taxa_dirty %>%
  select(sample_id:Cyanobacteria)

## this b is in wide format !!! booo. let's make this long
taxon_long <-
  taxon_clean %>%
  #transform into long-formatted dataframe
  pivot_longer(cols= Proteobacteria:Cyanobacteria, 
               names_to = "phylum", 
               values_to= "abundance")

## summarize!
taxon_long %>%
  group_by(phylum) %>%
  summarize(avg_abund <- mean(abundance))


##plot our data
ggplot(taxon_long, aes(x=sample_id, y=abundance, fill= phylum))+
  geom_bar(stat="identity")+
  theme(axis.text.x = element_text(angle=90))

##joining dataframes
head(sample)
head(taxon_clean)

##you can join by two different columns using by = c("thing1", "thing2)
combined <- inner_join(sample, taxon_clean, by = "sample_id")

#intuition check on filtering joins
length(unique(taxon_clean$sample_id))
length(unique(sample$sample_id))

##there is an issue in the naming of the September samples where
##in one df "Sep" is written for September samples, while it is written
## as "September" in the others

#we can use anti_join() to identify differences between data frames
anti_join(sample, taxon_clean)

##solving the issue!
taxon_clean_goodSept <- 
  taxon_clean %>%
  #replace our sample_id column with fixed septemebr names
  #using str_replace- this is really helpful and something i 
  #should consider using more! i normally do this in excel lol...
  mutate(sample_id = str_replace(sample_id, "Sep", "September"))

combined <- inner_join(sample, taxon_clean_goodSept, by = "sample_id")

#intuition check
dim(combined)

#add test
stopifnot(nrow(combined) == nrow(sample))

#write out our clean data into a  new file
write_csv(combined, "data/sample_and_taxon.csv")

#quick plot of chloroflexi
ggplot(data=combined, aes(x=depth, y=Chloroflexi))+
  geom_point()+
  geom_smooth()+
  theme_bw()

##now we can do data analysis !
