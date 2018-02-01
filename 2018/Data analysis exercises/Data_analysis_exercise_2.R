## Data analysis exercise 2
## BIO46, Winter 2018
## Name:

library(tidyr)
library(dplyr)
library(ggplot2)

########################
## Problem 1

# Set the working directory on Windows
setwd("C:/Users/your_username/Documents/BIO46")

# Set the working directory on Mac
setwd("/Users/your_username/Documents/BIO46")

########################


# Read in the csv file to a dataframe
isolates <- read.table("data/W4_isolates.csv", header = TRUE, sep = ",")


## How many isolates are there for each taxon?
# Use the isolates data
isolates %>%
  # Group the rows of the data by TaxonID
  group_by(TaxonID) %>%
  # Count the rows and save as a new column named Available_isolates.
  summarise(Available_isolates = n()) 


# Use the isolates data
isolates %>%
 # Count the rows and save as a new column named Available_isolates.
 summarise(Available_isolates = n())


# Summarise the data within taxa
isolates %>% 
  group_by(TaxonID) %>%
  summarise(Available_isolates = n(), 
            Growth_rate_mm_day = mean(Growth_rate_mm_day)
  )


########################
## Problem 2



#######################


# Fit a linear model with growth rate as the response and thallus location as the predictor.
mod_growth_loc <- lm(Growth_rate_mm_day ~ Thallus_location, data = isolates)

# Calculate the F statistic and p-value
anova(mod_growth_loc)

# Make a boxplot of growth rates of isolates from different thallus locations
ggplot(isolates, aes(x = Thallus_location, y = Growth_rate_mm_day)) +
  geom_boxplot() +
  labs(x = "Thallus location",
       y = expression("Growth rate"~(mm~day^-1))
  )

# Add a column that indicates whether an isolate occurred alone in the lichen.
isolates %>%
  mutate(Solo = Num_taxa == 1)

# Display isolates that occurred alone in the lichen.
isolates %>%
  mutate(Solo = Num_taxa == 1) %>%
  filter(Solo == TRUE)

# Display isolates that occured alone in the lichen 
isolates %>%
  filter(Num_taxa == 1)


# Display isolates that occured alone in the lichen
isolates %>%
  filter(Num_taxa == 1) %>%
  select(IsolateID, TaxonID, Growth_rate_mm_day, Num_taxa)


########################
## Problem 3



########################


########################
## Problem 4


########################



########################
## Problem 5



########################
