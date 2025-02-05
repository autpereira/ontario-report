# Plotting Lake Ontario Microbial Cell Abundances

##we first need to load our packages
library(tidyverse)

## load in the data
taxon <- read_csv(file = "taxon_abundance.csv")
sample <- read_csv(file = "sample_data.csv")
buoy <- read_csv(file = "buoy_data.csv")

#in-built functions with no input
Sys.Date() # What is the date
getwd()

sum(2,3)

##learning more about round()
?round()
round(3.1415) ## rounds to the nearest whole number
round(3.1415,3) ## rounds to the nearest 3 decimal places

##which will output 3.14?
round(x = 3.1415) #no
round(x = 3.1415, digits = 2) #yes
round(digits = 2, x = 3.1415) #yes
round(2, 3.1415) #no

## plotting !!
ggplot(data=sample)+
  aes(x= temperature, y=cells_per_ml/1000000, color = env_group, size = chlorophyll)+
  labs(x="Temp (°C)", y= "Cell Abundance (millions/mL)", title = "Does temperature affect abundance?")+
  geom_point()+
  theme_bw()

## buoy data
dim(buoy)
glimpse(buoy) #we can look at data structure here

ggplot(data = buoy)+
  aes(x= day_of_year, y= temperature, color = depth, group=sensor)+
  geom_line()+
  theme_bw()

##facet plots
ggplot(data = buoy)+
  aes(x= day_of_year, y= temperature, color = depth, group=sensor)+
  geom_line()+
  theme_bw()+
  facet_wrap(~buoy, scales = "fixed")

## you can use scales = "free" to allow variation in scales
## between subplots.... but why would you want that.....

ggplot(data = buoy)+
  aes(x= day_of_year, y= temperature, color = depth, group=sensor)+
  geom_line()+
  theme_bw()+
  facet_grid(rows = vars(buoy))

##plotting categorical data- cell abundances by environmental group

ggplot(data=sample)+
  aes(x=env_group, y=cells_per_ml, color = env_group, fill = env_group)+
  geom_jitter(aes(size = chlorophyll))+
  geom_boxplot(alpha = 0.3, outlier.shape = NA)+ ##outlier.shape removes double plotting
  theme_bw()

## alpha controls how opaque the box is
## we can add aes() to change just in one thing in one of the components
## of our plot within that speciif geom() function

ggsave("cells per env group.jpeg")

#x axis is total_nitrogen (plot #1) done
#or total_phosphorus (plot #2),
#y axis = cells_per_ml (transformed to million cells per mil like in class) done
#Human readable axis titles (with units) (unit not provided but yes)
#Informative title with a research question
#Points for each observation which are:
#size is mapped to temperature
#color is mapped to env_group
#A trend line using a linear model (hint: google/ChatGPT is your friend)
#Write the ggplot commands below that you would use to produce these plots

##Plot 1- Nitrogen
ggplot(data=sample)+
  aes(x=total_nitrogen, y=cells_per_ml/1000000, color = env_group)+
  geom_point(aes(size=temperature))+
  labs(y="Cell Abundance (millions/mL)", x= "Total Nitrogen", color = "Environmental Group", size = "Temperature (°C)", title = "How are Total Nitrogen and Cell Abundances Related in Lake Ontario?")+
  geom_smooth(method="lm", se=F)+
  theme_bw()

ggsave("nitrogen_plot.jpeg", width = 7, height = 4)
 
##Plot 2- Phosphorus
ggplot(data=sample)+
  aes(x=total_phosphorus, y=cells_per_ml/1000000, color = env_group)+
  geom_point(aes(size=temperature))+
  labs(y="Cell Abundance (millions/mL)", x= "Total Phosphorus", color = "Environmental Group", size = "Temperature (°C)", title="How are Total Phosphorus and Cell Abundances Related in Lake Ontario?")+
  geom_smooth(method="lm", se=F)+
  theme_bw()

ggsave("phosphorus_plot.jpeg", width = 7, height = 4)
