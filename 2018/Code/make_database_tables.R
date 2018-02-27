### Compiles database tables for BIO46 Winter 2018
### Author: Jes Coyle
### Created: 2/21/2018

# Set options
options(stringsAsFactors = FALSE)

# Load packages
library(dplyr)
library(tidyr)
library(googlesheets)

# Authorize googlesheets to access you Google Drive
gs_auth()


############################################
### Interaction Experiment Tables        ###

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


#############################################
### Environment data loggers Table        ###

# Load packages
library(lubridate) # round_date : for rounding times

# Define url for github repository
# Can alternatively read from local files
github_url <- "https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data/"
local_dir <- "Data"

# Read in sites data
sites <- read.csv(file.path(github_url, "BIO46_2018_sample_sites.csv"))

# Read in iButton file
#ibuttons <- read.csv(file.path(github_url, 'iButtons_Winter2018.csv'))
ibuttons <- read.csv(file.path(local_dir, "iButtons_Winter2018.csv"))

# Filter to sites used by BIO46 Winter 2018
ibuttons <- subset(ibuttons, Site %in% sites$Site)

# Read in relative humidity file
rh <- read.csv(file.path(github_url, 'RH_Winter2018.csv'))

# Format of Date_time column
time_form_ibutton <- '%m/%d/%y %I:%M:%S %p %z'
time_form_rh <- '%Y-%m-%d %H:%M:%S %z'

# Convert Date_time to datetime class
ibuttons$Date_time <- strptime(ibuttons$Date_time, format = time_form_ibutton, tz = "UTC")
rh$Date_time <- strptime(rh$Date_time, format = time_form_rh, tz = "UTC")

# Round to nearest 10 mins
ibuttons$Date_time <- round_date(ibuttons$Date_time, '10 mins')
rh$Date_time <- round_date(rh$Date_time, '10 mins')

# Rename Temp column to indicate which logger measured it
names(ibuttons)[3] <- 'Temp_ibutton'
names(rh)[3] <- 'Temp_rh'

# Merge ibuttons and rh data
env <- merge(ibuttons, rh, by = c('Site','Date_time'), all.x = TRUE)


### QA Checks ###

## Check for malfunctioning iButtons
bad_ibuttons <- subset(ibuttons, Temp_ibutton > 35 | Temp_ibutton < -10) # None

## Compare temperature measured by humidity loggers to temperature measured by ibuttons

# Make vector of sites at which relative humidity data was collected
rh_sites <- unique(rh$Site)

# Make plots comparing temperature difference at each site
par(mfrow = c(3,1))
par(mar = c(3,3,1,1))
for(this_site in rh_sites){
  use_data <- subset(env, Site == this_site & !is.na(Temp_rh))
  
  plot(use_data$Date_time, use_data$Temp_rh - use_data$Temp_ibutton, cex = .7)
  abline(h = seq(-10, 15, 5), col = 2)
  
}

# Most ibutton temp measurements are within 5 degrese of rh temp measurements.
# But, the extreme discrepancies happen diurnally, probably b/c light hits the black rh logger.
hist(env$Temp_ibutton - env$Temp_rh)

## Check how humidity measures vary across loggers
use_col <- c('black','blue','red')
names(use_col) <- rh_sites

start_date <- strptime('2018-01-19 00:00:00 -0800', time_form_rh, tz = "UTC")
end_date <- strptime('2018-02-22 00:00:00 -0800', time_form_rh, tz = "UTC")

use_env <- subset(env, Date_time > start_date & Date_time < end_date)
plot(use_env$Date_time, use_env$RH, type = 'n')
for(this_site in rh_sites){
  use_data <- subset(use_env, Site == this_site)
  
  lines(use_data$Date_time, use_data$RH, col = use_col[as.character(this_site)]) 
}

## Calculate humidity at trees withour RH data loggers ###

# Make a dataframe to hold the rh data replicates
rh_replicated <- rh

for(i in 1:nrow(sites)){
  
  # Get this site and determine it if already has humidity data
  this_site <- sites[i, "Site"]
  has_data <- this_site %in% rh_sites
  
  # If the tree doesn't have rh data
  if(!has_data){
    
    # Get the data that corresponds to the rh logger most similar to it
    # based on the Assigned_rh_tree column
    use_site <- sites[i, "RH_site"]
    use_data <- subset(rh, Site == use_site)
    use_data$Site <- this_site
    
    # Append to replicated data frame
    rh_replicated <- rbind(rh_replicated, use_data)
  }
}

# Create env by merging replicated_rh and ibuttons
env <- merge(ibuttons, rh_replicated, by = c('Site','Date_time'), all.x = TRUE)

# Calculate vapor pressure deficit (VPD) based on Magnus equation

# A function to calculate vapor pressure deficit from observed temp and estimated rh or dewpt
# We do not use the slight correction for pressure
# based on: Lawrence 2005, The Relationship between Relative Humidity and the Dewpoint Temperature in Moist Air
# http://journals.ametsoc.org/doi/pdf/10.1175/BAMS-86-2-225
# these constants are recommended for -40 : 50 Celcius
# The VPD units are in Pascals and temperature is in Celcius
calc_vpd <- function(temp, dewpt = NULL, rh = NULL, rh_temp = NULL){
  a <- 610.94
  b <- 17.625
  c <- 243.04
  
  # Calculate the vapor pressure of saturated air based on measured air temperature
  vp_sat <- a*exp((b*temp)/(c+temp))
  
  # If estimated dewpoint temperature is given, estimate the actual vapor pressure in the air 
  if(is.null(rh)){
    vp_act <- a*exp((b*dewpt)/(c+dewpt))
  }
  
  # If estimated relative humidity is given, estimate the actual vapor pressure in the air
  if(is.null(dewpt)){
    vp_sat_est <- a*exp((b*rh_temp)/(c+rh_temp))
    vp_act <- vp_sat_est*(rh/100)
  }
  
  # Vapor pressure deficit is the difference between the saturated vapor pressur in the canopy
  # and the actual vapor pressure at the weather station
  vpd <- vp_sat - vp_act
  
  vpd
}


# Use the VPD function to calculate actual VPD at trees where humidity logger were located
env$VPD_actual <- calc_vpd(temp = env$Temp_rh, dewpt = env$Dewpoint)
env$VPD_actual[!(env$Site %in% rh_sites)] <- NA

# Use the VPD function to calculate estimated VPD from ibutton temperature measurements
env$VPD_est <- calc_vpd(env$Temp_ibutton, dewpt = env$Dewpoint)

# Examine difference between estimated and actual VPD for rh_trees
par(mfrow = c(1,3))
par(mar = c(4,4,1,1))
for(this_site in rh_sites){
  use_data <- subset(env, Site == this_site)
  
  plot(VPD_est ~ VPD_actual, data = use_data) 
  abline(0, 1, col = use_col[as.character(this_site)])
}

hist(env$VPD_est - env$VPD_actual)
plot(env$VPD_actual, env$VPD_est - env$VPD_actual)


## Save data to file

# Add column indicating RH_site
env <- merge(env, sites[, c("Site", "RH_site")], all.x = TRUE)


# Convert times back to PST
env$Date_time <- with_tz(env$Date_time, tzone = "Etc/GMT+8") # PST

# Convert to text for saving
env$Date_time <-  format(env$Date_time, time_form_rh)

# Save file
write.csv(env, file.path(local_dir, 'BIO46_W2018_env_dataloggers.csv'), row.names = FALSE)



#############################################
### Environment data summary Table        ###

# Load packages
library(lubridate)
library(ggplot2)
library(dplyr)

# Define url for github repository
# Can alternatively read from local files
github_url <- "https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data/"
local_dir <- "Data"

# Read in sites data
sites <- read.csv(file.path(github_url, "BIO46_2018_sample_sites.csv"))

# Read in datalogger file
#loggers <- read.csv(file.path(github_url, 'BIO46_W2018_env_dataloggers.csv'))
loggers <- read.csv(file.path(local_dir, "BIO46_W2018_env_dataloggers.csv"))

# Set dates as actual dates
time_format <- '%Y-%m-%d %H:%M:%S %z'
loggers$Date_time <- strftime(loggers$Date_time, format = time_format, tz = "Etc/GMT+8")

## Examine humidity data for quality ##

hist(loggers$VPD_est)
hist(loggers$VPD_actual, add = T, col = "red")

# Plot time series
loggers %>%
  filter(!is.na(VPD_est)) %>%
  ggplot(aes(x = Date_time, y = VPD_est, group = Site)) +
    geom_line(aes(color = Site)) +
    geom_line(aes(y = VPD_actual), color = "red") +
    geom_hline(yintercept = 0, color = "red") +
    facet_wrap(~ RH_site)

# Actual VPD is rarely much less than 0 so negative measurements are probably due to 
# discrepancy between ibutton temperature and humidity logger.
# Set negative VPD to 0
loggers <- loggers %>%
  mutate(VPD_est = ifelse(VPD_est > 0, VPD_est, 0))

# Add a column to env that indicates which date the data was recorded
loggers$Date = as.Date(loggers$Date_time)

# A function that drops all NAs before calculating a given function or returns NA
na_drop = function(x, fun){
    if(length(na.omit(x) > 0)){
      x <- na.omit(x)
      y <- fun(x)
    } else {
      y <- NA
    }
  
  y
}

# Calculate daily environmental summaries
daily_env <- loggers %>%
  select(Site, Date, Temp_ibutton, VPD_est) %>% # Choose which columns to keep
  group_by(Site, Date) %>%
  summarise(Num_obs = n(),
            Temp_mean = mean(Temp_ibutton),
            Temp_min = min(Temp_ibutton),
            Temp_max = max(Temp_ibutton),
            Temp_range = Temp_max - Temp_min,
            VPD_mean = na_drop(VPD_est, mean),
            VPD_min = na_drop(VPD_est, min),
            VPD_max = na_drop(VPD_est, max),
            VPD_range = VPD_max - VPD_min)

# Drop days with fewer than 40 observations- usually from 10/31/2017
daily_env = filter(daily_env, Num_obs > 40)

# View distributions of daily measures
par(mfrow=c(3,3))
for(i in 4:11) hist(unlist(daily_env[,i]), main = names(daily_env)[i], xlab='')

# Summarize environment across dates for each site within months
month_summary <- daily_env %>%
  mutate(Month = month(Date)) %>%
  group_by(Site, Month) %>%
  summarise(Temp_mean = mean(Temp_mean), 
            Temp_min = mean(Temp_min), 
            Temp_max = mean(Temp_max), 
            Temp_range = mean(Temp_range),
            VPD_mean = na_drop(VPD_mean, mean), 
            VPD_min = na_drop(VPD_min, mean), 
            VPD_max = na_drop(VPD_max, mean), 
            VPD_range = na_drop(VPD_range, mean))

# Summarize environment across dates for each site within weeks
week_summary <- daily_env %>%
  mutate(Week = week(Date)) %>%
  group_by(Site, Week) %>%
  summarise(Temp_mean = mean(Temp_mean), 
            Temp_min = mean(Temp_min), 
            Temp_max = mean(Temp_max), 
            Temp_range = mean(Temp_range),
            VPD_mean = na_drop(VPD_mean, mean), 
            VPD_min = na_drop(VPD_min, mean), 
            VPD_max = na_drop(VPD_max, mean), 
            VPD_range = na_drop(VPD_range, mean))

# Summarize environment across dates for all available measurements
winter_summary <- daily_env %>%
  group_by(Site) %>%
  summarise(Temp_mean = mean(Temp_mean), 
            Temp_min = mean(Temp_min), 
            Temp_max = mean(Temp_max), 
            Temp_range = mean(Temp_range),
            VPD_mean = na_drop(VPD_mean, mean), 
            VPD_min = na_drop(VPD_min, mean), 
            VPD_max = na_drop(VPD_max, mean), 
            VPD_range = na_drop(VPD_range, mean))

# Combine all tables
winter_summary <- winter_summary %>%
  mutate(Time_period = "All")

month_summary <- month_summary %>%
  mutate(Time_period = paste("Month", Month)) %>%
  select(-Month)

week_summary <- week_summary %>%
  mutate(Time_period = paste("Week", Week)) %>%
  select(-Week)

env_summary <- bind_rows(winter_summary, month_summary) %>%
  bind_rows(week_summary) %>%
  select(Time_period, Site , starts_with("Temp"), starts_with("VPD"))
  

# Save data frame
write.csv(env_summary, file.path(local_dir, 'env_logger_summary.csv'), row.names=F)


