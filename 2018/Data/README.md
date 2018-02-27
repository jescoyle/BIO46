# Database Description

## Primary tables

### sites

**File name**: BIO46_sample_sites.csv

**Description**:

Location and environmental data for Jasper Ridge survey sites.

**Details**:


**Columns**:



### lichens

**File name**: lichens.csv

**Description**: 

Lichens collected at Jasper Ridge, including outcomes of growth and infection experiments.

**Details**:


**Columns**:


### fungi

**File name**: fungi.csv

**Description**:

Growth rates and identities of fungi isolated from lichens.

**Details**:


**Columns**:



### infection_prevalence

**File name**: infection_prevalence.csv

**Description**: 

Abundance of *E. prunastri* and infection prevalence at survey sites. 

**Details**:


**Columns**:



### interaction_experiment_byplate

**File name**: interaction_experiment_byplate.csv

**Description**: 

Outcome of fungal isolate interaction experiment for each plate.

**Details**:


**Columns**:



### interaction_experiment_bycompetitor

**File name**: interaction_experiment_bycompetitor.csv

**Description**:

Outcome of fungal isolate interaction experiment for each competitor on a plate.

**Details**:


**Columns**:


### env_logger_summary

**File name**: env_logger_summary.csv

**Description**:

Summaries of daily mean, min, max and range of temperature and vapor pressure deficit (VPD) for Nov 2017 - Feb 2018.

**Details**:

Daily mean, min, max and range values for temperature (C) and VPD are averaged for all time points measured (Time_period = "All") and within each month and week.


**Columns**:

## Raw data tables

### ibuttons

**File name**: iButtons_Winter2018.csv

**Description**:

iButton temperature data from survey sites.

**Details**:


**Columns**:


### humidity

**File name**: RH_Winter2018.csv

**Description**:

EL-USB-2 humidity logger data from three survey sites.

**Details**:


**Columns**:


### env_dataloggers

**File name**: BIO46_W2018_env_dataloggers.csv

**Description**:

Temperature and humidity data logged at each site. Humidity estimated at all but three sites based on measured values at nearest logger. Humidity data may be suspect since there were substantial discrepancies in temperature between ibuttons and EL-2-USB loggers at teh same site.

**Details**:


**Columns**:

