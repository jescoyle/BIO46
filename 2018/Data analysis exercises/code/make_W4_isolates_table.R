
library(tidyr)
library(dplyr)

# Load isolate IDs prepared for W4 lab
w4 <- read.csv("data/competition_experiment_isolates.csv")


# Load data on fungal isolates
fungi <- read.csv("data/BIO46_W2018_fungi.csv")

# Load taxon names
taxa <- read.csv("data/taxa.csv")

# Merge relevant data from fungi tables
w4 <- fungi %>%
  select(IsolateID, LichenID, TaxonID, Thallus_location, Growth_rate_mm_day) %>%
  right_join(w4)

# Merge taxon data
w4 <- taxa %>%
  select(TaxonID, Class, Order, Family, Species) %>%
  right_join(w4)


# Calculate number of taxa and isolates for each lichen and merge
w4 <- fungi %>%
  group_by(LichenID) %>%
  summarise(Num_isolates = n(),
            Num_taxa = length(unique(TaxonID[TaxonID != ""]))
  ) %>%
  right_join(w4)

# Add TreeID and fix column
w4 <- w4 %>%
  mutate(LichenID = substring(LichenID, 5),
       TreeID = gsub('-L[1-3]', '', LichenID)
  ) %>%
  select(IsolateID, 
         TaxonID, 
         LichenID,
         Thallus_location, 
         Growth_rate_mm_day,
         Num_isolates,
         Num_taxa,
         Class, Order, Family, Species
  )
         
# Save
write.csv(w4, "data/W4_isolates.csv")

