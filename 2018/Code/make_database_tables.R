### Compiles database tables for BIO46 Winter 2018
### Author: Jes Coyle
### Created: 2/21/2018

# Load packages
library(dplyr)
library(tidyr)
library(googlesheets)

# Authorize googlesheets to access you Google Drive
gs_auth()


############################################
### Interaction Experiment Table

# Register interaction experiment tables
gs_interaction_setup <- gs_key("12YGhmj9GUxRwN5PzzqfoM-97zFa1LXvJoVmhhUntWlI")
gs_interaction_outcome <- gs_key("19xCCkB6whFoAbojrx-YrpA267OYBIc4iHBvAgRFN328")

# Retrieve data
int_setup <- gs_read(gs_interaction_setup, as.is = TRUE)
int_outcome <- gs_read(gs_interaction_outcome, as.is = TRUE)

# Read fungal isolate data from GitHub
isolates <- read.csv("https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data%20analysis%20exercises/data/W4_isolates.csv",
                     as.is = TRUE)

# Merge setup and outcome tables
int_data <- full_join(int_setup, int_outcome)


# Add taxon names for each competitor
int_data <- int_data %>%
  gather(key = Competitor, value = IsolateID, Isolate1, Isolate2) %>% 
  mutate(Competitor = sub("Isolate", "", Competitor)) %>%
  left_join(isolates[, c("IsolateID", "TaxonID")]) %>%
  gather(key = ID_type, value = ID_value, TaxonID, IsolateID) %>%
  unite(ID, ID_type, Competitor) %>%
  spread(key = ID, value = ID_value)

# Remove - from culture type levels
int_data <- int_data %>%
  mutate(Culture_type = sub("-", "", Culture_type))

# Save table locally and upload to Google Drive later
write.csv(int_data, 
          file = "Data/interaction_experiment_byplate.csv",
          row.names = FALSE)


## Create a table where each row is a fungal isolate in an experiment

comp1 <- int_data %>%
  transmute(IsolateID = IsolateID_1, 
         TaxonID = TaxonID_1,
         Radius_mm_day7 = Isolate1_radius_mm_day7,
         Radius_mm_day14 = Isolate1_radius_mm_day14,
         Competitor_isolate = IsolateID_2,
         Competitor_taxon = TaxonID_2,
         Culture_type = Culture_type,
         PlateID = PlateID)

comp2 <- int_data %>%
  transmute(IsolateID = IsolateID_2, 
         TaxonID = TaxonID_2,
         Radius_mm_day7 = Isolate2_radius_mm_day7,
         Radius_mm_day14 = Isolate2_radius_mm_day14,
         Competitor_isolate = IsolateID_1,
         Competitor_taxon = TaxonID_1,
         Culture_type = Culture_type,
         PlateID = PlateID) %>%
  filter(Culture_type == "co-culture")

int_data_long <- bind_rows(comp1, comp2)

# Save table locally and upload to Google Drive later
write.csv(int_data_long, 
          file = "Data/interaction_experiment_bycompetitor.csv",
          row.names = FALSE)


###########################################
### Compile environmental data for sites






