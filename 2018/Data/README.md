# Database Description

## Primary tables

### sites

**File name**: BIO46_sample_sites.csv

**Description**:

Location and environmental data for Jasper Ridge survey sites.

**Details**:

Canopy cover variables are from Gap Light Analyzer (GLA) analysis of hemispherical digital photographs of taken at each site in April - May of 2017 (for the BIO 47 class).


**Columns**:

| Column name | Description |
|-------------|-------------|
| Site | Unique site number. Corresponds to the same Plant numbers used in BIO 47. |
| Canopy_openness_pct | Percent canopy openness. 100 = 100% open sky.|
| LAI_75deg | Leaf area index within 75 degree zenith angle. |
| Group | Group number assigned to survey the site. |
| UTM_E & UTM_N | Location of the site in UTM coordinates (zone 10). |
| RH_site | Site whose humidity logger was used to estimate humidity at this site. |


### lichens

**File name**: lichens.csv

**Description**: 

Lichens collected at Jasper Ridge, including outcomes of growth and infection experiments.

**Details**:

Each row corresponds to a lichen collected at Jasper Ridge on January 11, 2018. Lichens were used in two experiments: 1) a growth experiment in which the change in mass and health of lichens was observed before and after growing in a growth chamber for 6 weeks (at 22 C with 14 / 10 hr light / dark cycle) and 2) an infection experiment in which lichens the health of lichens was observed after infection with different fungal isolates (see infection_experiment table). 

**Columns**:

| Column name | Description |
|-------------|-------------|
| Team | Team that collected the lichen. |
| LichenID | Unique code identifying a lichen individual. |
| Site | Site where lichen was collected. |
| Substrate_type |  Whether lichen was collected from a tree or shrub. |
| Substrate_status |  Whether the substrate from which the lichen was collected was alive or dead. |
| Ascomata | Number of ascomata of *Unguiculariopsis lettaui* observed present under a dissecting microscope. |
| Experiment | Which experiment the lichens was used for. |
| Mass_mg_init | Initial mass in mg. Recorded only for lichens in the growth experiment. |
| Mass_mg_6weeks |  Mass after 6 weeks in the growth experiment. |
| Health | Categorical variable recording health status after 6 weeks. 1 = most healthy, 3 = least healthy. All lichens were initially at health status 1. |


### fungal_isolates

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

