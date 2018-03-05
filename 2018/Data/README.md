# Database Description

## Primary tables

### sites

**File name**: BIO46_sample_sites.csv

**Description**:

Location and environmental data for Jasper Ridge survey sites.

**Details**:

Each row corresponds to one site that was sampled for lichens in the BIO46 class. Site numbers correspond to the same plant numbers used by the BIO47 course. Canopy cover variables are from Gap Light Analyzer (GLA) analysis of hemispherical digital photographs of taken at each site in April - May of 2017 (for the BIO 47 class).

**Columns**:

| Column name | Description                                                          |
|-------------|----------------------------------------------------------------------|
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

| Column name | Description                                                          |
|-------------|----------------------------------------------------------------------|
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

**File name**: NOT YET PRESENT

**Description**:

Growth rates and identities of fungi isolated from lichens.

**Details**:


**Columns**:



### infection_prevalence

**File name**: infection_prevalence.csv

**Description**: 

Abundance of *E. prunastri* and infection prevalence at survey sites. 

**Details**:

Site were surveyed for *Evernia prunastri* abundance by searching for all *E. prunastri* present within a 1 x 3 meter plot centered on the station holding the ibutton. Lichens were not surveyed from branches that had fallen on the ground. The prevalence of *Unguiculariopsis lettaui* infecting *E. prunastri* was estimated by randomly choosing nine lichen thalli and inspecting them for ascomata with a 10x hand lens.

**Columns**:

| Column name | Description                                                          |
|-------------|----------------------------------------------------------------------|
| Site | Unique site number. |
| Date | Date when the site was surveyed. |
| Num_Eprunastri | Number of *Evernia prunastri* thalli. |
| Num_infected | Number of *Evernia purnastri* with ascomata from *Unguiculariopsis lettaui*. |
| Num_healthy | Number of *Evernia prunastri* that were not infected. |


### interaction_experiment_byplate

**File name**: interaction_experiment_byplate.csv

**Description**: 

Outcome of fungal isolate interaction experiment for each plate.

**Details**:

Fungal isolates were grown alone ("solo") or in competition with one other isolate ("co-culture") on 9 cm petri dishes filled with solid MEA media. To start te experiment, plugs of agar filled with fungal mycelia from the growing edge of a fresh culture were transfered with a plastic drinking straw to positions 3 cm apart from one another in the center of the plates. Culture grew for 1 - 2 weeks and the radius of each culture in the direction of the other culture was recorded each week. At the conclusion, the "winner" of the interaction was the isolate that was able to grow over the other isolate. If neither isolate grew over the other then the interaction was recorded as a "draw".

IsolateIDs correspond to fungal isolates described in the BIO46_W2017_fungi.csv table which can be found in [2018/Data analysis exercises/data](https://raw.githubusercontent.com/jescoyle/BIO46/master/2018/Data analysis exercises/data/BIO46_W2017_fungi.csv). See the taxa table for information on TaxonIDs.

This table has one row for each plate in the experiment.


| Column name | Description                                                          |
|-------------|----------------------------------------------------------------------|
| PlateID | Unique code identifying a plate. |
| Culture_type | Whether the isolate grew aone ("solo") or in competition with one other isolate ("co-culture"). |
| Isolate1_radius_mm_day7 | Radius of isolate 1 after 7 days in mm. |
| Isolate1_radius_mm_day14 | Radius of isolate 1 after 14 days in mm. |
| Isolate2_radius_mm_day7 | Radius of isolate 2 after 7 days in mm. Recorded only for co-culture plates. |
| Isolate2_radius_mm_day14 | Radius of isolate 2 after 14 days in mm. Recorded only for co-culture plates. |
| Isolate1_outcome and Isolate2_outcome | Whether isolate 1 or isolate 2 "won" or "lost" the interaction by growing over the other isolate. |
| IsolateID_1 and IsolateID_2| Codes identifying isolates 1 and 2. |
| TaxonID_1 and TaxonID_2 | Tentative taxa assigned to isolates 1 and 2 based on ITS sequences. |


### interaction_experiment_bycompetitor

**File name**: interaction_experiment_bycompetitor.csv

**Description**:

Outcome of fungal isolate interaction experiment for each competitor on a plate. 

**Details**:

See the descriprion for the interaction_experiment_byplate table. Each row in this table corresponds to a single isolate on a plate.

| Column name | Description                                                          |
|-------------|----------------------------------------------------------------------|
| IsolateID | Unique code identifying the isolate. |
| TaxonID | Tentative taxon assigned to the isolate based on ITS sequence. |
| Radius_mm_day7 | Radius after 7 days in mm. |
| Radius_mm_day14 | Radius after 14 days in mm. |
| Competitor_isolate | IsolateID of the fungal isolate that this isolate was plated with. Only reported for co-culture plates. |
| Competitor_taxon | TaxonID of the fungal isolate that this isolate was plated with. Only reported for co-culture plates. |
| Culture_type | Whether the isolate was grown alone ("solo") or in competition with another isolate ("co-culture") |
| PlateID | Code identifying which plate this data is from. |

### env_logger_summary

**File name**: env_logger_summary.csv

**Description**:

Summaries of daily mean, min, max and range of temperature and vapor pressure deficit (VPD) for Nov 2017 - Feb 2018 at each site. 

**Details**:

Daily mean, min, max and range values for temperature (C) and VPD are averaged for all time points measured (Time_period = "All") and within each month and week. For example, Month1 = January, Month2 =  February and Week1 = the first week of the year, Week2 = the second week of the year, etc.

Vapor pressure deficit difference between the vapor pressure of water in the air and the vapor pressure of water in air that is completely saturated. It is a measure of humidity and higher values correspond to drier air. Here we estimate VPD at each site using the Magnus equation to calculate VPD from actual temperature measured at each site and the the dewpoint temperature measured at three sites around Jasper Ridge. The humidity logger closest to the site was used to assign a dewpoint temperature, since this was only measured at three sites (see the sites table for which humidity loggers were assigned to each site). See [2018/Code/make_databases_tables.R](https://jescoyle.github.io/BIO46/2018/Code/make_database_tables.R) for more information.

| Column name | Description                                                          |
|-------------|----------------------------------------------------------------------|
| Time_period | Time period over which daily summary values were averaged. |
| Site | Site where temperature data was recorded. |
| Temp_mean | Average daily mean temperature in Celcius. |
| Temp_min | Average daily minimum temperature in Celcius. |
| Temp_max | Average daily maximum temperature in Celcius. |
| Temp_range | Average daily temperature range in Celcius. |
| VPD_mean | Average daily mean VPD in Pascals. |
| VPD_min | Average daily minimum VPD in Pascals. |
| VPD_max | Average daily maximum VPD in Pascals. |
| VPD_range | Average daily VPD range in Pascals. |


## Raw data tables

These tables were store data logger measurements and were used to calculate the summary environmental data in the env_logger_summary table.  [2018/Code/make_databases_tables.R](https://jescoyle.github.io/BIO46/2018/Code/make_database_tables.R) for more information.


### ibuttons

**File name**: iButtons_Winter2018.csv

**Description**:

iButton temperature data from survey sites.


### humidity

**File name**: RH_Winter2018.csv

**Description**:

EL-USB-2 humidity logger data from three survey sites.


### env_dataloggers

**File name**: BIO46_W2018_env_dataloggers.csv

**Description**:

Combines data from iButton and humidity data loggers. Humidity estimated at all but three sites based on measured values at nearest logger. Humidity data may be suspect since there were substantial discrepancies in temperature between ibuttons and EL-2-USB loggers at teh same site.
